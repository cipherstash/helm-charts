{{/*
Expand the name of the chart.
*/}}
{{- define "cipherstash-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cipherstash-proxy.fullname" -}}
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
{{- define "cipherstash-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cipherstash-proxy.labels" -}}
helm.sh/chart: {{ include "cipherstash-proxy.chart" . }}
{{ include "cipherstash-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cipherstash-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cipherstash-proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cipherstash-proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cipherstash-proxy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create namespace name
*/}}
{{- define "cipherstash-proxy.namespace" -}}
{{- if .Values.namespace.create }}
{{- .Values.namespace.name }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Create image name with tag
*/}}
{{- define "cipherstash-proxy.image" -}}
{{- printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) }}
{{- end }}

{{/*
Get database password secret name and key
*/}}
{{- define "cipherstash-proxy.databasePasswordSecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.databasePasswordSecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.databasePasswordSecretKey" -}}
{{- if .Values.secrets.create -}}
database-password
{{- else -}}
{{- .Values.secrets.external.databasePasswordSecret.key -}}
{{- end -}}
{{- end }}

{{/*
Get CipherStash client key secret name and key
*/}}
{{- define "cipherstash-proxy.cipherstashClientKeySecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.cipherstashClientKeySecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.cipherstashClientKeySecretKey" -}}
{{- if .Values.secrets.create -}}
cipherstash-client-key
{{- else -}}
{{- .Values.secrets.external.cipherstashClientKeySecret.key -}}
{{- end -}}
{{- end }}

{{/*
Get CipherStash client access key secret name and key
*/}}
{{- define "cipherstash-proxy.cipherstashClientAccessKeySecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.cipherstashClientAccessKeySecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.cipherstashClientAccessKeySecretKey" -}}
{{- if .Values.secrets.create -}}
cipherstash-client-access-key
{{- else -}}
{{- .Values.secrets.external.cipherstashClientAccessKeySecret.key -}}
{{- end -}}
{{- end }}

{{/*
Get database host secret name and key
*/}}
{{- define "cipherstash-proxy.databaseHostSecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.databaseHostSecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.databaseHostSecretKey" -}}
{{- if .Values.secrets.create -}}
database-host
{{- else -}}
{{- .Values.secrets.external.databaseHostSecret.key -}}
{{- end -}}
{{- end }}

{{/*
Get database name secret name and key
*/}}
{{- define "cipherstash-proxy.databaseNameSecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.databaseNameSecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.databaseNameSecretKey" -}}
{{- if .Values.secrets.create -}}
database-name
{{- else -}}
{{- .Values.secrets.external.databaseNameSecret.key -}}
{{- end -}}
{{- end }}

{{/*
Get database port secret name and key
*/}}
{{- define "cipherstash-proxy.databasePortSecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.databasePortSecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.databasePortSecretKey" -}}
{{- if .Values.secrets.create -}}
database-port
{{- else -}}
{{- .Values.secrets.external.databasePortSecret.key -}}
{{- end -}}
{{- end }}

{{/*
Get database username secret name and key
*/}}
{{- define "cipherstash-proxy.databaseUsernameSecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.databaseUsernameSecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.databaseUsernameSecretKey" -}}
{{- if .Values.secrets.create -}}
database-username
{{- else -}}
{{- .Values.secrets.external.databaseUsernameSecret.key -}}
{{- end -}}
{{- end }}

{{/*
Get CipherStash workspace CRN secret name and key
*/}}
{{- define "cipherstash-proxy.cipherstashWorkspaceCrnSecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.cipherstashWorkspaceCrnSecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.cipherstashWorkspaceCrnSecretKey" -}}
{{- if .Values.secrets.create -}}
cipherstash-workspace-crn
{{- else -}}
{{- .Values.secrets.external.cipherstashWorkspaceCrnSecret.key -}}
{{- end -}}
{{- end }}

{{/*
Get CipherStash client ID secret name and key
*/}}
{{- define "cipherstash-proxy.cipherstashClientIdSecret" -}}
{{- if .Values.secrets.create -}}
{{- printf "%s-secrets" (include "cipherstash-proxy.fullname" .) -}}
{{- else -}}
{{- .Values.secrets.external.cipherstashClientIdSecret.name -}}
{{- end -}}
{{- end }}

{{- define "cipherstash-proxy.cipherstashClientIdSecretKey" -}}
{{- if .Values.secrets.create -}}
cipherstash-client-id
{{- else -}}
{{- .Values.secrets.external.cipherstashClientIdSecret.key -}}
{{- end -}}
{{- end }} 