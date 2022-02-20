# kuboard-deploy-action
kuboard  ci/cd deploy action 

use:
```yaml
- name: deploy to k8s by kuboard
  uses: wertycn/kuboard-deploy-action
  with:
    - user: ""             # 'kuboard user name'
      access_key: ""       # 'kuboard access key'
      deploy_namespace: "" # 'deploy cluster namespace'
      server_name: ""      # 'deploy server name'
      docker_image: ""     # 'deploy server docker image'
      deploy_api_url: ""   # 'kuboard deploy (ci/cd) api url,eg http://YOUR_DOMAIN/kuboard-api/cluster/YOUR_CLUSTER_NAME/kind/CICDApi/YOUR_KUBOARD_NAME/resource/updateImageTag'
      deploy_kind: ""      # 'deploy pod kind,default value deployments (deployments,statefulsets,daemonsets,cronjobs,jobs)'
```

kuboard doc https://kuboard.cn/guide/cicd/
