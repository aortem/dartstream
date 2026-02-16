describe("Standard User Access Control", () => {
  const email = Cypress.env("standardUser").email;
  const password = Cypress.env("standardUser").password;

  beforeEach(() => {
    cy.visit("/");
    cy.login(email, password);
  });

  it("Should restrict access", () => {
    const adminRoutes = ["/dashboard/_analytics", "/dashboard/_audit-logs"];

    adminRoutes.forEach((route) => {
      cy.visit(route);
      cy.dataCy("upgrade-prompt")
        .should("be.visible")
        .and("include.text", "Upgrade your membership");
    });
  });

  it("Should restrict adding environment and ip restriction", () => {
    cy.visit("/dashboard/setting");
    cy.dataCy("Environments-button").click();
    cy.dataCy("add-environment-button").click();
    cy.contains("Standard user not allowed to add environment!").should(
      "be.visible"
    );
    cy.dataCy("restrictions-button").click();
    cy.dataCy("upgrade-prompt")
      .should("be.visible")
      .and("include.text", "Upgrade your membership");
  });
});
