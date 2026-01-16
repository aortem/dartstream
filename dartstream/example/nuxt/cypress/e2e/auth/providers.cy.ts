const providers = [
  'okta',
  'auth0',
  'cognito',
  'entraid',
  'transmit',
  'fingerprint',
  'ping',
]

providers.forEach((provider) => {
  describe(`Auth provider: ${provider}`, () => {
    it(`logs in using ${provider}`, () => {
      cy.login({ provider })
      cy.visit('/dashboard')
      cy.contains('Dashboard') // or any stable assertion
      cy.logout()
    })
  })
})
