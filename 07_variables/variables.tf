variable "filename" {
    description = "The name of the file to create"
    type = string
    //default = "lab07.txt"  // if not provided interactive mode will define the name. Can be -var="filename=interactive_var_flag.txt" or -var-file=variables.tfvars
}