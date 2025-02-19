{{/*
Return the chart name.
*/}}
{{- define "webhook-demo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the full name of the release, shortened.
If fullnameOverride is provided, use it; otherwise, use a truncated release name.
*/}}
{{- define "webhook-demo.fullname" -}}
{{- if .Values.fullnameOverride -}}
  {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- .Release.Name | trunc 20 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the chart name and version.
*/}}
{{- define "webhook-demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- end -}}
