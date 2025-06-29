import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import fetch from "node-fetch";
import {Request, Response} from "express";
admin.initializeApp();

export const githubAuth = functions.https.onRequest(
    {secrets: ["GITHUB_CLIENT_ID", "GITHUB_CLIENT_SECRET"]},
    async (req: Request, res: Response) => {
    // CORS対応（必要に応じて）
      res.set("Access-Control-Allow-Origin", "*");
      if (req.method === "OPTIONS") {
        res.set("Access-Control-Allow-Methods", "POST");
        res.set("Access-Control-Allow-Headers", "Content-Type");
        res.status(204).send("");
        return;
      }
      try {
        const code: string = req.body.code;
        const clientId: string | undefined = process.env.GITHUB_CLIENT_ID;
        const clientSecret: string | undefined = process.env.GITHUB_CLIENT_SECRET;
        if (!clientId || !clientSecret) {
          res
              .status(500)
              .json({error: "Missing GitHub OAuth environment variables."});
          return;
        }
        // 1. GitHubアクセストークン取得
        const tokenRes = await fetch(
            "https://github.com/login/oauth/access_token",
            {
              method: "POST",
              headers: {Accept: "application/json"},
              body: new URLSearchParams({
                client_id: clientId,
                client_secret: clientSecret,
                code: code,
              }),
            }
        );
        const tokenJson: any = await tokenRes.json();
        const accessToken: string = tokenJson.access_token;
        // 2. GitHubユーザー情報取得
        const userRes = await fetch("https://api.github.com/user", {
          headers: {Authorization: `token ${accessToken}`},
        });
        const userJson: any = await userRes.json();
        // 3. Firebaseカスタムトークン生成
        const firebaseToken = await admin
            .auth()
            .createCustomToken(`github:${userJson.id}`, {
              provider: "GITHUB",
              login: userJson.login,
              avatar_url: userJson.avatar_url,
            });
        res.json({
          token: firebaseToken,
          githubAccessToken: accessToken,
        });
      } catch (e: any) {
        res.status(500).json({error: e.toString()});
      }
    }
);
