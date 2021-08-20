output "id" {
  description = "Distinguished name (Dn) of the VMM Domain created by the module"
  value       = aci_vmm_domain.vmm.id
}

output "credentials_id" {
  description = "Distinguished name (Dn) of the VMM credentials object created by the module"
  value       = aci_vmm_credential.vc.id
}

output "controller_id" {
  description = "Distinguished name (Dn) of the VMM controller object created by the module"
  value       = aci_vmm_controller.vc.id
}