export function generateEmail() {
  const timestamp = Date.now();
  const randomSuffix = Math.floor(Math.random() * 1000);
  return `test${timestamp}${randomSuffix}@example.com`;
}
export function generatePassword() {
  return `Asdf123!@#+${Math.floor(Math.random() * 100000)}`;
}
