for team_dir in firewall-rules/*; do
    if [ -d "$team_dir" ] && [ -f "$team_dir/rules.yaml" ]; then
    team=$(basename "$team_dir")
    team_config=$(cat team-config.yaml)
    rules_config=$(cat $team_dir/rules.yaml)
    echo "Processing Firewall Rules for $team"

    # Apply configuration
    cd ./terraform/module
    terraform workspace new $team
    terraform workspace select $team -or-create=true

    terraform init -reconfigure -backend-config="prefix=terraform/firewall-rules/$team" 
    terraform apply -auto-approve -var="team_config_content=$team_config" -var="yaml_content=$rules_config"
    cd -
  fi
done