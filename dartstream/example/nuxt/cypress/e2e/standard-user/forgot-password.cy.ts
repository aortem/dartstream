describe("Forgot Password Flow (Firebase)", () => {
  const email = Cypress.env("standardUser").email;

  beforeEach(() => {
    // Suppress Vue Router navigation guard errors during testing
    cy.on("uncaught:exception", (err) => {
      // Ignore Vue Router transition errors
      if (
        err.message.includes(
          "Cannot read properties of undefined (reading 'matched')"
        ) ||
        err.message.includes(
          "Cannot read properties of undefined (reading 'left')"
        )
      ) {
        return false;
      }
      // Let other errors fail the test
      return true;
    });

    cy.visit("/auth/forgot");
    cy.get('[data-cy="email-input"]').should("be.visible");
  });

  it("should show success toast and redirect to login after Firebase reset", () => {
    cy.intercept(
      "POST",
      "**/identitytoolkit.googleapis.com/v1/accounts:sendOobCode**",
      {
        statusCode: 200,
        body: { email: email },
      }
    ).as("sendPasswordReset");

    cy.get('[data-cy="email-input"]').type(email);
    cy.get('[data-cy="reset-password-button"]').click();
    cy.wait("@sendPasswordReset");

    cy.get('div[role="alert"].Vue-Toastification__toast-body')
      .should("be.visible")
      .and("contain.text", "Password reset email sent");

    cy.url().should("include", "/auth/login");
  });
});
