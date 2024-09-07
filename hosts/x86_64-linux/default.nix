{ lib, inputs, ... } @ args:
{
  nixosConfigurations = import ./framework args;
}
