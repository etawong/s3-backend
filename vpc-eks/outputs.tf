output "private" {
  value = aws_subnet.private.*.id
}

output "public" {
  value = aws_subnet.public.*.id

}


output "node_role" {
  value = module.iam_role.node_role
}

output "cluster_role" {
  value = module.iam_role.cluster_role
}
