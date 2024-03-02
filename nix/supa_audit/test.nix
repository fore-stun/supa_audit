{ runCommandLocal
, supaAudit
, supaAuditShell
}:

runCommandLocal "supa_audit_check"
{
  buildInputs = supaAuditShell.buildInputs;
  FAIL_ON_FAILURE = false;
} ''
  cp -v "${supaAudit.src}/Makefile" .
  cp -rv "${supaAudit.src}/test" .
  chmod -R +w test

  function save_results() {
    STATUS=$?
    echo "Exit status ''${STATUS}" >&2
    if ! (( ''${FAIL_ON_FAILURE} )) || ! (( STATUS )) ; then
      mv -v results "$out"
      exit 0
    fi
  }
  echo FAIL_ON_FAILURE "''${FAIL_ON_FAILURE}" >&2
  trap save_results EXIT

  "pg_${supaAudit.pgVersion}_supa_audit" make installcheck
''
