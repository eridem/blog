const express = require('express')
const packageInfo = require('./package.json')
const app = express()

// Default endpoint
app.get('/', function (req, res) {
  console.log(`Called ${new Date().toString()}`)

  res.setHeader('Content-Type', 'application/json');
  res.send(JSON.stringify({ message: `Hello from version ${packageInfo.version}` }))
})

// Health endpoint
app.get('/health', function (req, res) {

  res.setHeader('Content-Type', 'application/json');
  res.send(JSON.stringify({ status: 'ok' }))
})

// Exit with error
app.get('/terminate', function (req, res) {

  console.error('Ops! Error, we are gonna exit.')
  process.exit(1)
})

app.get('/env', function (req, res) {
  const greeting = process.env.GREETING || 'Myself'

  res.setHeader('Content-Type', 'application/json');
  res.send(JSON.stringify({ greeting }))
})

// Start listening on 3000
app.listen(process.env.PORT || 3000)
