#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/../config/aws_config')

vpc = AWS::EC2.new.vpcs.first

vpc.instances.group_by { |inst| inst.tags['Role'] }.each do |role, instances|
  if role == nil || role.length == 0 then next end 
  puts "#{role}:"
  instances.each do |inst|
    sec_groups = inst.security_groups.collect {|sg| sg.name }.join(', ')
    puts "  Name: #{inst.tags['Name']}"
    puts "  ID: #{inst.id}" 
    puts "  AMI: #{inst.image_id}"
    puts "  Private IP: #{inst.private_ip_address}"
    puts "  Elastic IP: #{inst.public_ip_address}" if inst.public_ip_address
    puts "  Security groups: #{sec_groups}"
    puts
  end 
  puts
end