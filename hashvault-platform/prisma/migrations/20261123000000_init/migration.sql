
CREATE TYPE "Role" AS ENUM ('USER', 'ADMIN');
CREATE TYPE "PayoutStatus" AS ENUM ('REQUESTED', 'APPROVED', 'REJECTED', 'PAID');

CREATE TABLE "User" (
  "id" TEXT NOT NULL,
  "email" TEXT NOT NULL,
  "passwordHash" TEXT NOT NULL,
  "role" "Role" NOT NULL DEFAULT 'USER',
  "referralCode" TEXT NOT NULL,
  "referredById" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE UNIQUE INDEX "User_referralCode_key" ON "User"("referralCode");

CREATE TABLE "MiningSnapshot" (
  "id" TEXT NOT NULL,
  "userId" TEXT NOT NULL,
  "hashRateTh" DECIMAL(18,6) NOT NULL,
  "grossUsd" DECIMAL(18,6) NOT NULL,
  "serviceFeeUsd" DECIMAL(18,6) NOT NULL,
  "operatingUsd" DECIMAL(18,6) NOT NULL,
  "netUsd" DECIMAL(18,6) NOT NULL,
  "source" TEXT NOT NULL DEFAULT 'DEMO',
  "recordedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "MiningSnapshot_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "MiningSnapshot_userId_recordedAt_idx"
ON "MiningSnapshot"("userId", "recordedAt");

CREATE TABLE "Payout" (
  "id" TEXT NOT NULL,
  "userId" TEXT NOT NULL,
  "amountUsd" DECIMAL(18,2) NOT NULL,
  "destination" TEXT NOT NULL,
  "status" "PayoutStatus" NOT NULL DEFAULT 'REQUESTED',
  "transactionHash" TEXT,
  "adminNote" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Payout_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "Payout_status_createdAt_idx"
ON "Payout"("status", "createdAt");

CREATE TABLE "AuditLog" (
  "id" TEXT NOT NULL,
  "actorId" TEXT,
  "action" TEXT NOT NULL,
  "entityType" TEXT NOT NULL,
  "entityId" TEXT,
  "metadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "AuditLog_createdAt_idx" ON "AuditLog"("createdAt");

ALTER TABLE "User"
ADD CONSTRAINT "User_referredById_fkey"
FOREIGN KEY ("referredById") REFERENCES "User"("id")
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "Payout"
ADD CONSTRAINT "Payout_userId_fkey"
FOREIGN KEY ("userId") REFERENCES "User"("id")
ON DELETE RESTRICT ON UPDATE CASCADE;
