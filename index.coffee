#!/usr/bin/env coffee

mu      = require 'mu2'
path    = require 'path'
http    = require 'http'
express = require 'express'
{ log } = console

PORT = 8080

tasks = []
mu.root = __dirname

app = express()
app.use express.bodyParser()

app.get '/', (req, resp) ->
  mu.clearCache() if process.env is 'development'

  html = mu.compileAndRender 'home.html', { tasks }
  html.pipe resp

app.post '/tasks', (req, resp) ->
  { text } = req.body
  text or= '(empty)'

  tasks.push { text }
  log "add: #{text}"
  log require('util').inspect tasks
  resp.redirect '/'

app.post '/tasks/:text/delete', (req, resp) ->
  { text } = req.params

  # remove a task
  log "remove: #{text}"
  tasks = (t for t in tasks when t.text isnt text)
  resp.redirect '/'

server = http.createServer app
server.listen PORT, ->
  log "listening on #{PORT}"

