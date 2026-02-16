import {
  generateEmail,
  generatePassword,
} from "~/cypress/fixtures/generateUserDetails";

let email = generateEmail();
let password = generatePassword();

describe("Signup & Login Flow", () => {
  before(() => {
    cy.visit("http://localhost:3000/auth/register");
  });

  it("Should signup successfully with valid credentials", () => {
    // Signup now goes via Firebase, then backend token exchange at /auth/google
    cy.intercept("POST", "**/auth/google").as("registerUser");

    cy.singUp(email, password, password);
    cy.wait("@registerUser").then((interception) => {
      cy.log("Signup API response: ", interception.response);
    });
    cy.get('div[role="alert"].Vue-Toastification__toast-body')
      .should("be.visible")
      // The app toasts "Password Sign-In successful!" after token exchange
      .invoke('text')
      .should((t) => {
        expect(t).to.match(/Sign-In successful!/);
      });
  });

  it("Should not signup with mismatched passwords", () => {
    const newEmail = generateEmail();
    cy.visit("/auth/register");
    cy.singUp(newEmail, "Password123!", "Password321!");
    cy.get('div[role="alert"].Vue-Toastification__toast-body')
      .should("be.visible")
      .and("have.text", "Passwords do not match!");
  });

  it("Should not signup with already registered email", () => {
    cy.visit("/auth/register");
    cy.singUp(email, password, password); // reuse the same email
    cy.get('div[role="alert"].Vue-Toastification__toast-body')
      .should("be.visible")
      .invoke('text')
      .should((t) => {
        // Accept either raw code or friendly message
        expect(t).to.match(/already in use|EMAIL_EXISTS/i);
      });
  });

  it("Login with valid credentials and create sandbox user", () => {
    cy.login(email, password);

    // intercept checkout API
    cy.intercept(
      "POST",
      "https://dev-api.dartstream.com/api/billing/checkout"
    ).as("checkout");
    cy.dataCy("button-sign-up-standard").click();

    cy.wait("@checkout").then((interception) => {
      const statusCode = interception.response?.statusCode;
      const message =
        interception.response?.body?.message || "No message provided";

      expect(
        statusCode,
        `Checkout API call should return 200 but got ${statusCode}. Message: ${message}`
      ).to.eq(200);
    });
  });
});
