---
name: aws-bedrock
description: AWS deployment and Amazon Bedrock integration during a timed build, plus interview talking points. Use when the assignment or interviewer mentions AWS, Bedrock, Amplify, App Runner, IAM, or calling Claude through AWS infrastructure.
---

# AWS / Bedrock in a Timed Build

## First: clarify which of three different things "Bedrock" means here

1. **The app calls an LLM via Bedrock** — Bedrock is model access, not app hosting. Use the
   AWS SDK's Converse API with Claude model IDs; auth is IAM credentials, not an Anthropic
   API key. This is what enterprises mean by "we use Bedrock."
2. **Hosting the app on AWS** — Bedrock doesn't do this. Fast options ranked by
   speed-to-live: Amplify Hosting (git-connected, Next.js aware) > App Runner (container) >
   anything involving hand-rolled ECS/EC2 (do not attempt in 2 hours).
3. **Claude Code itself running against Bedrock** — set `CLAUDE_CODE_USE_BEDROCK=1` with AWS
   credentials configured, and Claude Code routes through the org's Bedrock account instead
   of Anthropic's API. This is the enterprise deployment story for the tool itself. Knowing
   this exists is a strong signal in an AWS shop — verify current setup details in the
   Claude Code docs before claiming specifics.

## If the app needs Claude via Bedrock (option 1), minimal TypeScript

```ts
import { BedrockRuntimeClient, ConverseCommand } from "@aws-sdk/client-bedrock-runtime";

const client = new BedrockRuntimeClient({ region: process.env.AWS_REGION });
const res = await client.send(new ConverseCommand({
  modelId: "anthropic.claude-sonnet-4-6",   // verify exact model ID in the Bedrock console — IDs change
  messages: [{ role: "user", content: [{ text: prompt }] }],
  inferenceConfig: { maxTokens: 1024 },
}));
```

Model must be enabled in the account's Bedrock model access settings first — if a fresh AWS
account is involved, check that BEFORE writing integration code; access grants can stall you.

## Time-pressure ruling

Unless the interviewer requires AWS hosting, deploy the app to Vercel and, if AI features
are needed, call the Anthropic API directly — then SAY: "in an AWS shop I'd swap this client
for Bedrock's Converse API with IAM auth; it's a one-file change." That sentence
demonstrates the knowledge without spending 30 minutes on IAM. If they require AWS hosting,
use Amplify Hosting and budget 25 minutes for the first successful deploy.
