# Terraform para criar OKE com recursos Always Free

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Buscar AD
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Buscar imagem ARM (Ubuntu)
data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Criar VCN
resource "oci_core_virtual_network" "vcn" {
  cidr_block     = "10.0.0.0/16"
  display_name   = "oke-free-vcn"
  compartment_id = var.compartment_id
}

resource "oci_core_subnet" "oke_subnet" {
  cidr_block        = "10.0.10.0/24"
  display_name      = "oke-free-subnet"
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_virtual_network.vcn.id
  prohibit_public_ip_on_vnic = false
}

# Cluster OKE
resource "oci_containerengine_cluster" "oke" {
  compartment_id     = var.compartment_id
  name               = "oke-free-cluster"
  vcn_id             = oci_core_virtual_network.vcn.id
  kubernetes_version = "v1.27.2"
  endpoint_config {
    is_public_ip_enabled = true
  }
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.1.0.0/16"
      services_cidr = "10.2.0.0/16"
    }
  }
}

# Node Pool com A1.Flex (Always Free)
resource "oci_containerengine_node_pool" "oke_nodepool" {
  cluster_id         = oci_containerengine_cluster.oke.id
  compartment_id     = var.compartment_id
  name               = "oke-free-nodes"
  kubernetes_version = "v1.27.2"
  node_shape         = "VM.Standard.A1.Flex"
  node_config_details {
    size = 2
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.oke_subnet.id
    }
    node_shape_config {
      ocpus         = 1
      memory_in_gbs = 6
    }
  }
  node_source_details {
    source_type = "IMAGE"
    image_id    = data.oci_core_images.ubuntu_arm.images[0].id
  }
}

output "oke_cluster_id" {
  value = oci_containerengine_cluster.oke.id
}

output "oke_kubeconfig_command" {
  value = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.oke.id} --file ~/.kube/config --region ${var.region} --token-version 2.0.0"
}
