var spawn = require('child_process').spawn
var githubhook = require('githubhook')

var github = githubhook({
  host: '0.0.0.0',
  port: '9001',
  path: '/',
})

github.on('pull_request:' + PROJECT.repository, function(ref, data) {
  if (
    data.pull_request &&
    data.action === 'closed' &&
    data.pull_request.merged === true &&
    data.pull_request.base.ref === 'master'
  ) {
    var dockerfile = 'docker.app'
    var branch = 'origin/master'
    var scriptName = '/home/ubuntu/healthlinx/deploy_local.sh'
    var environment = 'stage'
    console.log('running ' + scriptName + ' ' + branch + ' ' + environment)

    var child = spawn('bash',
      [scriptName, branch, environment]
    )
    child.stdout.setEncoding('utf8')
    child.stdout.on('data', function(data) {
        console.log(data)
    })
    child.stderr.setEncoding('utf8')
    child.stderr.on('data', function(error) {
        console.log(error)
    })
  }
})

github.listen()
