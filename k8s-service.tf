resource "kubectl_manifest" "backend_service" {
  depends_on = [kubectl_manifest.backenddeployment]
  yaml_body  = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: ${var.project_name}
spec:
  type: LoadBalancer
  selector:
    app: ${var.project_name}
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
YAML
}