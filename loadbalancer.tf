# loadbalancer.tf
# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "lb" {
  name                = "web-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name                = "backend-pool"
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
}

# Health Probe
resource "azurerm_lb_probe" "lb_probe" {
  name                = "http-probe"
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 15
  number_of_probes    = 2
}

# Load Balancing Rule
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "http-load-balancing-rule"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_pool.id
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

# Associate VMs with Load Balancer Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "lb_backend_assoc" {
  count                    = 2
  network_interface_id     = azurerm_network_interface.web_nic[count.index].id
  ip_configuration_name    = "web-ip-config"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

# Application Gateway Public IP
resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "appgw-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Application Gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "app-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.web_subnet.id
  }
  frontend_port {
    name = "frontend-port"
    port = 80
  }
  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id
  }
  backend_address_pool {
    name = "backend-pool"
    backend_addresses = [
      for nic in azurerm_network_interface.web_nic : {
        ip_address = nic.ip_configuration[0].private_ip_address
      }
    ]
  }
  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }
  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
  }
}
