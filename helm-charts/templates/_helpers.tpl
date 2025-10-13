{{- define "prayag-new1.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "prayag-new1.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "prayag-new1.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
