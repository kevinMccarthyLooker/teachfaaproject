datagroup: default {
  sql_trigger: select count(*) from flights ;;
  max_cache_age: "1 hour"
}

persist_with: default
