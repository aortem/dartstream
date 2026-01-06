/// <reference types="cypress" />

declare global {
  namespace Cypress {
    interface Chainable {
      login(email: string, password: string): Chainable<void>;
      dataCy(element: string): Chainable<JQuery<HTMLElement>>;
      singUp(
        email: string,
        password: string,
        confirmPassword: string
      ): Chainable<void>;
    }
  }
}

Cypress.Commands.add("dataCy", (value: string) => {
  return cy.get(`[data-cy="${value}"]`);
});

Cypress.Commands.add("login", (email, password) => {
  cy.visit("/auth/login");
  cy.dataCy("input-email").type(email);
  cy.dataCy("input-password").type(password);
  // Email/password now flows through Firebase first, then backend token exchange
  cy.intercept("POST", "**/auth/google").as(
    "loginUser"
  );
  cy.dataCy("button-login").click();
  cy.wait("@loginUser").then((interception) => {
    const statusCode = interception.response?.statusCode;
    const message = interception.response?.body?.message;

    // Log the message first (only if statusCode is not 200)
    if (statusCode !== 200) {
      cy.log("Login API call failed, with message: " + message);
    }

    // Now assert (this will still fail the test if status != 200)
    expect(statusCode, "Login API call should return 200").to.eq(200);
    cy.wait(2000); // wait for 2 seconds to ensure the dashboard loads completely
  });
});

Cypress.Commands.add("singUp", (email, password, confirmPassword) => {
  cy.visit("/auth/register");
  cy.dataCy("input-email").type(email);
  cy.dataCy("input-password").type(password);
  cy.dataCy("input-confirm-password").type(confirmPassword);
  cy.dataCy("button-submit").click();
});
