// Shared flag + targeting types for frontend components.
export type RuleOperator =
  | "equals"
  | "notEquals"
  | "contains"
  | "doesNotContain"
  | "greaterThan"
  | "lessThan"
  | "inList"
  | "notInList"
  | "matches"
  | "startsWith"
  | "endsWith";

export type TargetingRuleValue =
  | string
  | number
  | boolean
  | Array<string | number | boolean>;

export interface TargetingRulePayload {
  attribute: string;
  operator: RuleOperator;
  value: TargetingRuleValue;
  name?: string;
  description?: string;
}

export interface TargetingRule extends TargetingRulePayload {
  id: string;
}

export interface FlagVariation {
  id?: string;
  name?: string;
  value: any;
  description?: string;
}

export interface FlagDetail {
  key?: string;
  name?: string;
  description?: string;
  status?: string;
  environment?: string;
  type?: string;
  defaultValue?: any;
  flag_variations?: FlagVariation[];
  rules?: TargetingRule[];
  rollout?: Record<string, any> | null;
  createdAt?: string;
  updatedAt?: string;
}

export interface CustomAttributeDefinition {
  type?: string;
  description?: string;
  allowedValues?: string[] | null;
}
