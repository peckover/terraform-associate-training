capgemini_email  = "jonathan.peckover@capgemini.com"
expiration_date = "2025-01-29"
local_network_cidr = [ "90.213.10.75/32" ]

sg_ingress_rules = [ 
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  },
  {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  },
  {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
  }
]

shopping_list = {
      "apples" = "4"
      "bread" = "1"
      "beans" = "3"
      "things I don't need" = "10"
    }
