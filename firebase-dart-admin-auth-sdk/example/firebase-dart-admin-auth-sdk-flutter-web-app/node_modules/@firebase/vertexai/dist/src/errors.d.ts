/**
 * @license
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { FirebaseError } from '@firebase/util';
import { VertexAIErrorCode, CustomErrorData } from './types';
/**
 * Error class for the Vertex AI in Firebase SDK.
 *
 * @public
 */
export declare class VertexAIError extends FirebaseError {
    readonly code: VertexAIErrorCode;
    readonly customErrorData?: CustomErrorData | undefined;
    /**
     * Constructs a new instance of the `VertexAIError` class.
     *
     * @param code - The error code from <code>{@link VertexAIErrorCode}</code>.
     * @param message - A human-readable message describing the error.
     * @param customErrorData - Optional error data.
     */
    constructor(code: VertexAIErrorCode, message: string, customErrorData?: CustomErrorData | undefined);
}
