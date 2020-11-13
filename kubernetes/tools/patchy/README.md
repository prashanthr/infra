# Patchy

## USAGE

`cd ./kubernetes/tools/patchy`

1) Edit ./config/apps.json for the list of apps your want to patch

  ```
  [{
    "name": "app-1",
    "namespace": "app1-namespace",
    "deploymentName": "app1-deployment",
  }, {
    "name": "app-2",
    "namespace": "app2-namespace-or-app1-namespace",
    "deploymentName": "app2-deployment",
  }]

  ```

2. Run the script with no params
   
   ```
    ./scripts/patchy.sh
   ```

3. You can now safely view your ouput under `./kubernetes/tools/patchy/output`. Finally run the script as follows
   ```
    ./output/patch-apps.sh
   ```
