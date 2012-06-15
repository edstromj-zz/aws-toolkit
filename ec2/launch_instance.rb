#!/usr/bin/env ruby

require '../config/aws_config'
require 'aws-sdk'

(private_ip, security_group_id, image_id, subnet_id) = ARGV

# Check for necessary parameters
unless private_ip && security_group_id && image_id && subnet_id
  puts "Usage #{$0} private_ip security_group_id image_id subnet_id"
  exit 1
end

# Instantiate EC2 object
ec2 = AWS::EC2.new

new_inst = ec2.instances.create(
  :image_id => image_id,
  :subnet => ec2.subnets[subnet_id],
  :instance_type => 'm1.large',
  :key_name => your_key_name,
  :private_ip => private_ip,
  :security_group_ids => { security_group_id })

puts "Waiting for new instance with id #{new_inst.id} to become available..."

sleep 1 while new_inst.status == :pending
new_inst.add_tag('Name', :value => private_ip)

puts '...ready'

