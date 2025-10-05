resource "kubectl_manifest" "backenddeployment" {
  depends_on = [data.aws_eks_cluster.cluster]
  yaml_body  = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${var.project_name}
  labels:
    app: ${var.project_name}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${var.project_name}
  template:
    metadata:
      labels:
        app: ${var.project_name}
    spec:
      initContainers:
        - name: run-migrations
          image: herlessi/${var.project_name}:latest
          command: ["npx", "knex", "migrate:latest", "--env", "desenvolvimento"]
          env:
            - name: POSTGRES_HOST
              valueFrom:
                configMapKeyRef:
                  name: database-fiap-fase3
                  key: POSTGRES_HOST
            - name: POSTGRES_PORT
              valueFrom:
                configMapKeyRef:
                  name: database-fiap-fase3
                  key: POSTGRES_PORT
            - name: POSTGRES_USER
              valueFrom:
                configMapKeyRef:
                  name: database-fiap-fase3
                  key: POSTGRES_USER
            - name: POSTGRES_DB
              valueFrom:
                configMapKeyRef:
                  name: database-fiap-fase3
                  key: POSTGRES_DB
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: database-secret
                  key: password
                  
      containers:
        - name: ${var.project_name}
          image: herlessi/${var.project_name}:latest
          ports:
            - containerPort: 8080
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 15
            timeoutSeconds: 2
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 10
            timeoutSeconds: 2
            failureThreshold: 3
          env:
            - name: POSTGRES_HOST
              valueFrom:
                configMapKeyRef:
                  name: database-fiap-fase3
                  key: POSTGRES_HOST
            - name: POSTGRES_PORT
              valueFrom:
                configMapKeyRef:
                  name: database-fiap-fase3
                  key: POSTGRES_PORT
            - name: POSTGRES_USER
              valueFrom:
                configMapKeyRef:
                  name: database-fiap-fase3
                  key: POSTGRES_USER
            - name: POSTGRES_DB
              valueFrom:
                configMapKeyRef:
                  name: database-fiap-fase3
                  key: POSTGRES_DB
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: database-secret
                  key: password
            # - name: JWT_SECRET
            #   valueFrom:
            #     secretKeyRef:
            #       name: todolist-jwt-secret
            #       key: jwt-secret
          resources:
            requests:
              memory: "256Mi"
              cpu: "500m"
            limits:
              memory: "512Mi"
              cpu: "1"
YAML
}