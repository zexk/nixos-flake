# nixpkgs overlay that adds my custom packages

_self: super: with super; {

  self.maintainers = super.maintainers.override {
    lolisamurai = {
      email = "lolisamurai@animegirls.xyz";
      github = "Francesco149";
      githubId = 973793;
      name = "Francesco Noferi";
    };
  };
}
