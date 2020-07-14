#/bin/bash
# Example usage
# cd ./kubernetes/tools/kubify
# 
# SECRET=hello \
# ./scripts/secreto.sh

ENCODED_SECRET=$(echo -n $SECRET | base64)
echo $ENCODED_SECRET | pbcopy
