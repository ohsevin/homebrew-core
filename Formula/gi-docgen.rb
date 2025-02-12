class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  revision 1
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  stable do
    url "https://files.pythonhosted.org/packages/25/11/64ea759ba610d7442e8827306d1adba233ca69547d2a0e974f5ea74fa320/gi-docgen-2022.1.tar.gz"
    sha256 "f91d879ff28d7d5265cde84275ee510e32386bfeb7ec6203a647342aead55cec"

    # Make log.log() thread safe to avoid corrupt text. Remove in the next release.
    patch do
      url "https://gitlab.gnome.org/GNOME/gi-docgen/-/commit/26e3cb5ddf26bb6f33c2fdf171f409a57364be9e.diff"
      sha256 "767e664d14c2b0344650af3ed359b70316deaab4b8abc20782810843ce75e81e"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7abcfcd23fa893d6387a5f9f3f67f2a1829e28c09dd33625ea701fc2d0d97073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e128ec590ba7fd3e4d80a3c159a27a916e707523f15cc747b1be718ba6d85a0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c91ccf66103d18e5588c17f3cc0b90203e79c8683bde00c9d7dd476328586c7b"
    sha256 cellar: :any_skip_relocation, monterey:       "89c4899de71503e5fd54d336b2b7eb435ffbe3fb3c4d95478b1c81f8ff80c82c"
    sha256 cellar: :any_skip_relocation, big_sur:        "81aa6da48688b43d0f7b811744bcbb5c28ab50cd0804ac6d0b79cc955f7c8f97"
    sha256 cellar: :any_skip_relocation, catalina:       "49270200ea1a463e7f620a45667203d21d92ec2ca2625b6caa9191bfc7c88b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7978df359336ed12bc4a3a8b5f3c9586814fa64c2e8806841e0ac134ce75726"
  end

  depends_on "python@3.10"

  # Source for latest version is not available on PyPI, so using GitHub tarball instead.
  # Issue ref: https://github.com/leohemsted/smartypants.py/issues/8
  resource "smartypants" do
    url "https://github.com/leohemsted/smartypants.py/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "b98191911ff3b4144ef8ad53e776a2d0ad24bd508a905c6ce523597c40022773"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/89/e3/b36266381ae7a1310a653bb85f4f3658c462a69634fa9b2fef76252a50ed/Jinja2-3.1.1.tar.gz"
    sha256 "640bed4bb501cbd17194b3cace1dc2126f5b619cf068a726b98192a0fde74ae9"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/15/06/d60f21eda994b044cbd496892d4d4c5c708aa597fcaded7d421513cb219b/Markdown-3.3.6.tar.gz"
    sha256 "76df8ae32294ec39dcf89340382882dfa12975f87f45c3ed1ecdb1e8cefc7006"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typogrify" do
    url "https://files.pythonhosted.org/packages/8a/bf/64959d6187d42472acb846bcf462347c9124952c05bd57e5769d5f28f9a6/typogrify-2.0.7.tar.gz"
    sha256 "8be4668cda434163ce229d87ca273a11922cb1614cb359970b7dc96eed13cb38"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"brew.toml").write <<~EOS
      [library]
      description = "Homebrew gi-docgen formula test"
      authors = "Homebrew"
      license = "BSD-2-Clause"
      browse_url = "https://github.com/Homebrew/brew"
      repository_url = "https://github.com/Homebrew/brew.git"
      website_url = "https://brew.sh/"
    EOS

    (testpath/"brew.gir").write <<~EOS
      <?xml version="1.0"?>
      <repository version="1.2"
                  xmlns="http://www.gtk.org/introspection/core/1.0"
                  xmlns:c="http://www.gtk.org/introspection/c/1.0">
        <namespace name="brew" version="1.0" c:identifier-prefixes="brew" c:symbol-prefixes="brew">
          <record name="Formula" c:type="Formula">
            <field name="name" writable="1">
              <type name="utf8" c:type="char*"/>
            </field>
          </record>
        </namespace>
      </repository>
    EOS

    output = shell_output("#{bin}/gi-docgen generate -C brew.toml brew.gir")
    assert_match "Creating namespace index file for brew-1.0", output
    assert_predicate testpath/"brew-1.0/index.html", :exist?
    assert_predicate testpath/"brew-1.0/struct.Formula.html", :exist?
    assert_match %r{Website.*>https://brew.sh/}, (testpath/"brew-1.0/index.html").read
    assert_match(/struct.*Formula.*{/, (testpath/"brew-1.0/struct.Formula.html").read)
  end
end
