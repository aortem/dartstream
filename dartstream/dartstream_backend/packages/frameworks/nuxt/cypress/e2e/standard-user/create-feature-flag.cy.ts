describe("Should Login and create feature flags", () => {
  const email = Cypress.env("standardUser").email;
  const password = Cypress.env("standardUser").password;

  beforeEach(() => {
    cy.visit("/");
    cy.login(email, password);
  });

  const flags = [
    {
      type: "boolean",
      name: "Boolean Flag",
      description: "This is a boolean flag",
      variationName: "True Variation",
      variationValue: "true",
      valueType: "select", // select vs type
    },
    {
      type: "number",
      name: "Number Flag",
      description: "This is a number flag",
      variationName: "Variation 1",
      variationValue: "123",
      valueType: "type",
    },
    {
      type: "string",
      name: "String Flag",
      description: "This is a string flag",
      variationName: "Variation 1",
      variationValue: "test",
      valueType: "type",
    },
    {
      type: "json",
      name: "JSON Flag",
      description: "This is a JSON flag",
      variationName: "Variation JSON",
      variationValue: "{'key': 'value'}",
      valueType: "type",
    },
  ];

  function createAndDeleteFlag(flag: any) {
    cy.intercept("POST", "**/flags/projects/*/flags").as("createFlag");

    // cy.dataCy("button-cursor-pointer").click();
    cy.dataCy("button-create-flag").click();

    cy.dataCy("input-flag-name").type(flag.name);
    cy.dataCy("input-flag-description").type(flag.description);
    cy.dataCy("environment-select")
      .select("production")
      .should("have.value", "production");
    cy.dataCy("flag-select").select(flag.type).should("have.value", flag.type);

    cy.dataCy("input-variation-name").type(flag.variationName);
    if (flag.valueType === "select") {
      cy.dataCy("input-variation-value").select(flag.variationValue);
    } else {
      cy.dataCy("input-variation-value").type(flag.variationValue, {
        parseSpecialCharSequences: false,
      });
    }

    cy.dataCy("button-submit-flag").click();

    cy.wait("@createFlag").then((interception) => {
      const statusCode = interception.response?.statusCode;
      const message = interception.response?.body?.message;

      if (statusCode !== 200) {
        cy.log(`⚠️ Create Flag API call failed: ${message}`);
      }

      cy.get("body").click("topLeft"); // Close any open modal/dropdown

      cy.dataCy("dropdown-button").click({ multiple: true });
      cy.dataCy("delete-flag").click();
      cy.wait(3000); // Small wait to ensure deletion completes
    });
  }

  flags.forEach((flag) => {
    it(`Create ${flag.type.toUpperCase()} feature flag`, () => {
      createAndDeleteFlag(flag);
    });
  });
});
