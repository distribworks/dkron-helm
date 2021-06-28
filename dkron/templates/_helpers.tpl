{{/*
Expand the name of the chart.
*/}}
{{- define "dkron.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dkron.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dkron.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Server common labels
*/}}
{{- define "dkron.serverLabels" -}}
helm.sh/chart: {{ include "dkron.chart" . }}
{{ include "dkron.serverSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Server selector labels
*/}}
{{- define "dkron.serverSelectorLabels" -}}
app.kubernetes.io/name: {{ include "dkron.name" . }}-server
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Agent common labels
*/}}
{{- define "dkron.agentLabels" -}}
helm.sh/chart: {{ include "dkron.chart" . }}
{{ include "dkron.agentSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Agent selector labels
*/}}
{{- define "dkron.agentSelectorLabels" -}}
app.kubernetes.io/name: {{ include "dkron.name" . }}-agent
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Sommon labels
*/}}
{{- define "dkron.labels" -}}
helm.sh/chart: {{ include "dkron.chart" . }}
app.kubernetes.io/name: {{ include "dkron.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dkron.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dkron.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "dkron.bootstrapExpect" -}}
{{- if .Values.server.autoscaling.enabled }}
{{- max (sub .Values.server.autoscaling.minReplicas 1) 1  }}
{{- else }}
{{- max (sub .Values.server.replicaCount 1) 1  }}
{{- end }}
{{- end }}