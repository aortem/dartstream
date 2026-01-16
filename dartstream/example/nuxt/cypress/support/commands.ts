/// <reference types="cypress" />

declare global {
  namespace Cypress {
    interface Chainable {
      /**
       * Logs in via DartStream directly (provider-agnostic)
       */
      login(overrides?: {
        email?: string
        password?: string
        provider?: string
      }): Chainable<void>

      /**
       * Logs out via DartStream
       */
      logout(): Chainable<void>

      /**
       * data-cy selector helper
       */
      dataCy(element: string): Chainable<JQuery<HTMLElement>>

      /**
       * Registers a user via DartStream
       */
      signUp(overrides?: {
        email?: string
        password?: string
      }): Chainable<void>
    }
  }
}

/* ----------------------------------
 * data-cy helper (unchanged)
 * ---------------------------------- */
Cypress.Commands.add('dataCy', (value: string) => {
  return cy.get(`[data-cy="${value}"]`)
})

/* ----------------------------------
 * Provider-agnostic login
 * ---------------------------------- */
Cypress.Commands.add('login', (overrides = {}) => {
  const provider =
    overrides.provider ||
    Cypress.env('DS_AUTH_PROVIDER') ||
    'okta'

  cy.request({
    method: 'POST',
    url: 'http://localhost:8080/auth/sign-in',
    body: {
      email: overrides.email || 'test@dartstream.dev',
      password: overrides.password || 'password123',
      provider,
      __e2e__: true, // 👈 tells DartStream to mock provider safely
    },
    failOnStatusCode: false,
  }).then((res) => {
    expect(res.status).to.eq(200)
  })
})

/* ----------------------------------
 * Logout
 * ---------------------------------- */
Cypress.Commands.add('logout', () => {
  cy.request('POST', 'http://localhost:8080/auth/logout')
})

/* ----------------------------------
 * Provider-agnostic signup
 * ---------------------------------- */
Cypress.Commands.add('signUp', (overrides = {}) => {
  cy.request({
    method: 'POST',
    url: 'http://localhost:8080/auth/register',
    body: {
      email: overrides.email || 'newuser@dartstream.dev',
      password: overrides.password || 'password123',
      __e2e__: true,
    },
    failOnStatusCode: false,
  }).then((res) => {
    expect(res.status).to.eq(200)
  })
})
