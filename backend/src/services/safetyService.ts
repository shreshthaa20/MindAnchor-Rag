import { pool } from "../config/database";

export interface SafetyAssessment {
  hasCrisisRisk: boolean;
  riskLevel: "none" | "possible" | "imminent";
  response?: string;
}

const possibleRiskPatterns = [
  /\bsuicid(e|al)\b/i,
  /\bself[-\s]?harm\b/i,
  /\bhurt myself\b/i,
  /\bkill myself\b/i,
  /\bend my life\b/i,
  /\bi do not want to live\b/i,
  /\bcan't go on\b/i,
  /\bno reason to live\b/i,
  /\bhopeless\b/i,
  /\bharm others\b/i,
  /\bhurt someone\b/i,
];

const imminentRiskPatterns = [
  /\bi am going to kill myself\b/i,
  /\bi'm going to kill myself\b/i,
  /\bi will kill myself\b/i,
  /\bi have a plan\b/i,
  /\btonight is the night\b/i,
  /\bgoodbye forever\b/i,
];

export const assessSafetyRisk = (
  message: string
): SafetyAssessment => {
  const hasImminentRisk = imminentRiskPatterns.some((pattern) =>
    pattern.test(message)
  );

  if (hasImminentRisk) {
    return {
      hasCrisisRisk: true,
      riskLevel: "imminent",
      response:
        "I'm really sorry you're feeling this much pain. Your safety matters right now. Please contact local emergency services immediately, contact local crisis support, or reach out to a trusted person who can stay with you. If you can, move away from anything you could use to hurt yourself or someone else while you get help. MindAnchor is a support tool, not a replacement for emergency or professional care.",
    };
  }

  const hasPossibleRisk = possibleRiskPatterns.some((pattern) =>
    pattern.test(message)
  );

  if (hasPossibleRisk) {
    return {
      hasCrisisRisk: true,
      riskLevel: "possible",
      response:
        "I'm really sorry you're carrying this. You do not have to handle it alone. If you might hurt yourself, hurt someone else, or feel unable to stay safe, please contact local emergency services now, contact local crisis support, or reach out to a trusted person nearby. MindAnchor can support you, but it is not a replacement for crisis or professional care.",
    };
  }

  return {
    hasCrisisRisk: false,
    riskLevel: "none",
  };
};

export const logSafetyEvent = async ({
  userId,
  eventType,
  riskLevel,
  source,
  message,
}: {
  userId: number | undefined;
  eventType: string;
  riskLevel: string;
  source: string;
  message: string;
}): Promise<void> => {
  await pool.query(
    `
    INSERT INTO safety_events
      (user_id, event_type, risk_level, source, message_preview)
    VALUES ($1, $2, $3, $4, $5)
    `,
    [
      userId ?? null,
      eventType,
      riskLevel,
      source,
      message.slice(0, 500),
    ]
  );
};
