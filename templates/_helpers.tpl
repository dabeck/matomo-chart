{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "matomo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "matomo.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "matomo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "matomo.mariasecret" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "matomo.imagePullSecrets" -}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Create correct host port for maridb
*/}}
{{- define "mariadb.host" -}}
{{- if not .Values.mariadb.deployChart -}}
{{ .Values.mariadb.auth.host }}
{{- else if eq .Values.mariadb.architecture "replication" -}}
{{ printf "%s-mariadb-primary" (.Release.Name) }}
{{- else -}}
{{ printf "%s-mariadb" (.Release.Name) }}
{{- end }}
{{- end }}
{{- define "mariadb.port" -}}
{{- if not .Values.mariadb.deployChart -}}
{{ .Values.mariadb.auth.port }}
{{- else -}}
{{ .Values.mariadb.primary.service.port }}
{{- end }}
{{- end }}

{{/*
Set archiver domain based on first ingres host or value
*/}}
{{- define "matomo.archiver.domain" -}}
{{- if not (empty .Values.archiver.domain) }}
{{- .Values.archiver.domain -}}
{{- else if (not (empty .Values.ingress.hosts)) -}}
{{- if  (not (empty (first .Values.ingress.hosts))) -}}
{{- first .Values.ingress.hosts -}}
{{- end }}
{{- else -}}
{{ required (printf "You must set an ingress.host or an archiver.domain to run external archiver") nil }}
{{- end }}
{{- end }}