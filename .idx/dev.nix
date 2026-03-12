{ pkgs, ... }: {

  # ─────────────────────────────────────────────────────
  #  Crystal-Code.git — ProXLegendYT IDX Workspace
  #  Google Project IDX dev.nix configuration
  # ─────────────────────────────────────────────────────

  channel = "stable-24.05";

  packages = with pkgs; [

    # ── VM Engine ──────────────────────────────────────
    qemu_kvm          # QEMU with KVM support
    qemu-utils        # qemu-img, qemu-nbd, etc.
    cloud-image-utils # cloud-localds (cloud-init seed creator)

    # ── Network & SSH ──────────────────────────────────
    openssh           # SSH client
    iproute2          # ip, ss commands
    nettools          # ifconfig, netstat

    # ── System Tools ───────────────────────────────────
    sudo              # privilege escalation
    procps            # pgrep, pkill, ps, free
    lsof              # list open files / port check
    util-linux        # mount, lsblk, flock
    coreutils         # basic GNU tools

    # ── Crypto & Security ──────────────────────────────
    openssl           # password hashing (openssl passwd)

    # ── Download Tools ─────────────────────────────────
    curl              # HTTP client
    wget              # file downloader

    # ── General Utilities ──────────────────────────────
    git               # version control
    unzip             # extract .zip files
    zip               # create .zip files
    screen            # terminal multiplexer (keep VMs running)
    tmux              # alternative terminal multiplexer
    htop              # interactive process viewer
    nano              # simple text editor
    vim               # advanced text editor

  ];

  # ─────────────────────────────────────────────────────
  #  Environment Variables
  # ─────────────────────────────────────────────────────
  env = {
    VM_DIR       = "/home/user/Crystal-Code.git/vms";
    TERM         = "xterm-256color";
    COLORTERM    = "truecolor";
  };

  # ─────────────────────────────────────────────────────
  #  IDX Workspace Hooks
  # ─────────────────────────────────────────────────────
  idx = {
    workspace = {

      # Runs once when workspace is first created
      onCreate = {
        make-vm-dir  = "mkdir -p /home/user/Crystal-Code.git/vms";
        make-runfile = "chmod +x /home/user/Crystal-Code.git/run.sh 2>/dev/null || true";
        welcome      = ''
          echo ""
          echo "╔══════════════════════════════════════════╗"
          echo "║   💎 Crystal-Code.git Workspace Ready!   ║"
          echo "║      by ProXLegendYT                     ║"
          echo "╚══════════════════════════════════════════╝"
          echo ""
          echo "  Run:  bash run.sh   to start the VPS manager"
          echo ""
        '';
      };

      # Runs every time the workspace opens
      onStart = {
        check-kvm = ''
          if [ -e /dev/kvm ]; then
            echo "✅ KVM is available — full speed VM mode!"
          else
            echo "⚠️  KVM not available — VMs will use TCG (software) mode"
          fi
        '';
        show-tip = ''
          echo "💡 Tip: Use 'screen' or 'tmux' to keep your VM running in background"
          echo "💡 SSH into VM: ssh -p 2222 <username>@localhost"
        '';
      };

    };

    # ─────────────────────────────────────────────────
    #  IDX Previews (optional — remove if not needed)
    # ─────────────────────────────────────────────────
    previews = {
      enable = true;
      previews = {
        web = {
          command = [ "echo" "No web preview for VPS manager" ];
          manager = "web";
        };
      };
    };

  };

}
