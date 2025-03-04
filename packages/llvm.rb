require 'package'

class Llvm < Package
  description 'The LLVM Project is a collection of modular and reusable compiler and toolchain technologies. The optional packages clang, lld, lldb, polly, compiler-rt, libcxx, libcxxabi, and openmp are included.'
  homepage 'http://llvm.org/'
  if ARCH == 'i686'
    @_ver = '11.1.0'
    version @_ver
  else
    @_ver = '12.0.1'
    version "#{@_ver}-1"
  end
  license 'Apache-2.0-with-LLVM-exceptions, UoI-NCSA, BSD, public-domain, rc, Apache-2.0 and MIT'
  compatibility 'all'
  source_url "https://github.com/llvm/llvm-project/archive/llvmorg-#{@_ver}.tar.gz"
  source_sha256 '66b64aa301244975a4aea489f402f205cde2f53dd722dad9e7b77a0459b4c8df'

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/llvm/12.0.1-1_armv7l/llvm-12.0.1-1-chromeos-armv7l.tpxz',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/llvm/12.0.1-1_armv7l/llvm-12.0.1-1-chromeos-armv7l.tpxz',
       i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/llvm/11.1.0_i686/llvm-11.1.0-chromeos-i686.tar.xz',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/llvm/12.0.1-1_x86_64/llvm-12.0.1-1-chromeos-x86_64.tpxz'
  })
  binary_sha256({
    aarch64: '324cb80793345bcca65f986c659cafae25dc64b2e546acffb7c441d6f771127d',
     armv7l: '324cb80793345bcca65f986c659cafae25dc64b2e546acffb7c441d6f771127d',
       i686: '3a514f96c846d777c838fef6c585d2278abf2a586bfaeacfd3e2bccc9ffce838',
     x86_64: 'fc83b1d1a1b98d0579003f0b212a8eeae3716c78b70e765180415472676ac4ef'
  })

  depends_on 'ocaml' => :build
  depends_on 'py3_pygments' => :build
  depends_on 'ccache' => :build
  depends_on 'elfutils' # R
  depends_on 'gcc11' # R or gcc11

  case ARCH
  when 'aarch64', 'armv7l'
    # LLVM_TARGETS_TO_BUILD = 'ARM;AArch64;AMDGPU'
    # LLVM_TARGETS_TO_BUILD = 'all'.freeze
    @ARCH_C_FLAGS = "-ltinfow -fPIC -march=armv7-a -mfloat-abi=hard -ccc-gcc-name #{CREW_BUILD}"
    @ARCH_CXX_FLAGS = "-fPIC -march=armv7-a -mfloat-abi=hard -ccc-gcc-name #{CREW_BUILD}"
    @ARCH_LDFLAGS = ''
    @ARCH_LTO_LDFLAGS = "#{@ARCH_LDFLAGS} -flto=thin"
    # compiler-rt fails with
    # [2967/6683] Building CXX object projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o
    # FAILED: projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o
    # CCACHE_CPP2=yes CCACHE_HASHDIR=yes /usr/local/bin/ccache /usr/local/bin/clang++ -DHAVE_RPC_XDR_H=1 -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -Iprojects/compiler-rt/lib/sanitizer_common -I/usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/compiler-rt/lib/sanitizer_common -Iinclude -I/usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/llvm/include -I/usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/compiler-rt/lib/sanitizer_common/.. -fPIC -march=armv7-a -mfloat-abi=hard -ccc-gcc-name armv7l-cros-linux-gnueabihf -flto=thin -fuse-ld=lld -fvisibility-inlines-hidden -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wno-noexcept-type -Wnon-virtual-dtor -Wsuggest-override -Wno-comment -fdiagnostics-color -flto=thin -Wall -std=c++14 -O3 -DNDEBUG  -fPIC -fno-builtin -fno-exceptions -fomit-frame-pointer -funwind-tables -fno-stack-protector -fno-sanitize=safe-stack -fvisibility=hidden -fno-lto -O3 -gline-tables-only -nostdinc++ -fno-rtti -std=c++14 -MD -MT projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o -MF projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o.d -o projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonSymbolizer.armhf.dir/sanitizer_unwind_linux_libcdep.cpp.o -c /usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/compiler-rt/lib/sanitizer_common/sanitizer_unwind_linux_libcdep.cpp
    # clang-11: warning: argument unused during compilation: '-fuse-ld=lld' [-Wunused-command-line-argument]
    # /usr/local/tmp/crew/llvm.20210420052043.dir/llvm-project-llvmorg-12.0.0/compiler-rt/lib/sanitizer_common/sanitizer_unwind_linux_libcdep.cpp:63:3: error: use of undeclared identifier '_Unwind_VRS_Result'; did you mean '_Unwind_Resume'?
    # _Unwind_VRS_Result res = _Unwind_VRS_Get(ctx, _UVRSC_CORE,
    # ^~~~~~~~~~~~~~~~~~
    # _Unwind_Resume
    LLVM_PROJECTS_TO_BUILD = 'clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;lld;polly;openmp'.freeze
  when 'i686'
    # LLVM_TARGETS_TO_BUILD = 'X86'.freeze
    # Because ld.lld: error: undefined symbol: __atomic_store
    # Polly demands fPIC
    @ARCH_C_FLAGS = '-ltinfow -latomic -fPIC'
    @ARCH_CXX_FLAGS = '-latomic -fPIC'
    # Because getting this error:
    # ld.lld: error: relocation R_386_PC32 cannot be used against symbol isl_map_fix_si; recompile with -fPIC
    # So as per https://github.com/openssl/openssl/issues/11305#issuecomment-602003528
    @ARCH_LDFLAGS = '-Wl,-znotext'
    @ARCH_LTO_LDFLAGS = "#{@ARCH_LDFLAGS} -flto=thin"
    LLVM_PROJECTS_TO_BUILD = 'clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly;openmp'.freeze
  when 'x86_64'
    # LLVM_TARGETS_TO_BUILD = 'X86;AMDGPU'
    # LLVM_TARGETS_TO_BUILD = 'all'.freeze
    @ARCH_C_FLAGS = '-ltinfow -fPIC'
    @ARCH_CXX_FLAGS = '-fPIC'
    @ARCH_LDFLAGS = ''
    @ARCH_LTO_LDFLAGS = "#{@ARCH_LDFLAGS} -flto=thin"
    LLVM_PROJECTS_TO_BUILD = 'clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly;openmp'.freeze
  end
  @ARCH_C_LTO_FLAGS = "#{@ARCH_C_FLAGS} -flto=thin -fuse-ld=lld"
  @ARCH_CXX_LTO_FLAGS = "#{@ARCH_CXX_FLAGS} -flto=thin -fuse-ld=lld"
  # LLVM_PROJECTS_TO_BUILD = 'clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly;openmp'.freeze

  # Using Targets 'all' for non-i686 because otherwise mesa complains.
  # This may be patched upstream as per
  # https://reviews.llvm.org/rG1de56d6d13c083c996dfd44a32041dacae037d66
  LLVM_TARGETS_TO_BUILD = 'all'.freeze

  def self.patch
    # This keeps system libraries from being linked in as dependencies on a build host image, such as in docker.
    # Uncomment the rest of this section if you need to.
    # system "sudo rm /lib#{CREW_LIB_SUFFIX}/libncurses.so.5 || true"
    # system "sudo rm /usr/lib#{CREW_LIB_SUFFIX}/libform.so || true"
    # system "sudo ln -s #{CREW_LIB_PREFIX}/libncurses.so.6 /lib#{CREW_LIB_SUFFIX}/libncurses.so.5 || true"
    # system "sudo ln -s #{CREW_LIB_PREFIX}/libform.so /usr/lib#{CREW_LIB_SUFFIX}/libform.so || true"
  end

  def self.build
    ############################################################
    puts "Building LLVM Targets: #{LLVM_TARGETS_TO_BUILD}".lightgreen
    puts "Building LLVM Projects: #{LLVM_PROJECTS_TO_BUILD}".lightgreen
    ############################################################
    ############################################################
    puts 'Setting compile to use python3'.lightgreen
    ############################################################
    system "grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'"

    ############################################################
    # puts "Downloading binutils #{BINUTILS_BRANCH} src to enable gold plugin build".lightgreen
    ############################################################
    # system "git config --global advice.detachedHead false"
    # As per https://github.com/SVF-tools/SVF/wiki/Install-LLVM-Gold-Plugin-on-Ubuntu
    # system "git clone --depth 1 --branch #{BINUTILS_BRANCH} git://sourceware.org/git/binutils-gdb.git binutils"

    Dir.mkdir 'builddir'
    Dir.chdir 'builddir' do
      system "echo '#!/bin/bash
machine=\$(gcc -dumpmachine)
version=\$(gcc -dumpversion)
gnuc_lib=#{CREW_LIB_PREFIX}/gcc/\${machine}/\${version}
clang -B \${gnuc_lib} -L \${gnuc_lib} \"\$@\"' > clc"
      system "echo '#!/bin/bash
machine=\$(gcc -dumpmachine)
version=\$(gcc -dumpversion)
cxx_sys=#{CREW_PREFIX}/include/c++/\${version}
cxx_inc=#{CREW_PREFIX}/include/c++/\${version}/\${machine}
gnuc_lib=#{CREW_LIB_PREFIX}/gcc/\${machine}/\${version}
clang++ -fPIC  -rtlib=compiler-rt -stdlib=libc++ -cxx-isystem \${cxx_sys} -I \${cxx_inc} -B \${gnuc_lib} -L \${gnuc_lib} \"\$@\"' > clc++"
      system "env LLVM_IAS=1 PATH=#{CREW_LIB_PREFIX}/ccache/bin:#{CREW_PREFIX}/bin:/usr/bin:/bin LD=ld.lld \
            cmake -G Ninja \
            -DLLVM_ENABLE_LTO=Thin \
            -DCMAKE_C_COMPILER=$(which clang) \
            -DCMAKE_CXX_COMPILER=$(which clang++) \
            -DCMAKE_INSTALL_PREFIX=#{CREW_PREFIX} \
            -DLLVM_DEFAULT_TARGET_TRIPLE=#{CREW_BUILD} \
            -DCMAKE_C_COMPILER_TARGET=#{CREW_BUILD} \
            -DCMAKE_ASM_COMPILER_TARGET=#{CREW_BUILD} \
            -DLLVM_TARGETS_TO_BUILD=\'#{LLVM_TARGETS_TO_BUILD}' \
            -DCMAKE_BUILD_TYPE=Release \
            -DLLVM_LIBDIR_SUFFIX='#{CREW_LIB_SUFFIX}' \
            -DCMAKE_LINKER=$(which ld.lld) \
            -D_CMAKE_TOOLCHAIN_PREFIX=llvm- \
            -DLLVM_BUILD_LLVM_DYLIB=ON \
            -DLLVM_LINK_LLVM_DYLIB=ON \
            -DLLVM_CCACHE_BUILD=ON \
            -DLLVM_ENABLE_FFI=ON \
            -DLLVM_ENABLE_RTTI=ON \
            -DCMAKE_C_FLAGS='#{@ARCH_C_LTO_FLAGS}' \
            -DCMAKE_CXX_FLAGS='#{@ARCH_CXX_LTO_FLAGS}' \
            -DCMAKE_EXE_LINKER_FLAGS='#{@ARCH_LTO_LDFLAGS}' \
            -DLLVM_PARALLEL_LINK_JOBS=1 \
            -DPYTHON_EXECUTABLE=$(which python3) \
            -DLLVM_INSTALL_UTILS=ON \
            -DLLVM_BINUTILS_INCDIR='#{CREW_PREFIX}/include' \
            -DLLVM_OPTIMIZED_TABLEGEN=ON \
            -DLLVM_ENABLE_TERMINFO=ON \
            -DLLVM_ENABLE_PROJECTS='#{LLVM_PROJECTS_TO_BUILD}' \
            -DLIBUNWIND_C_FLAGS='-fno-exceptions -funwind-tables' \
            -DLIBUNWIND_CXX_FLAGS='-fno-exceptions -funwind-tables' \
            -DLIBUNWIND_SUPPORTS_FUNWIND_TABLES_FLAG=ON \
            -DLIBUNWIND_SUPPORTS_FNO_EXCEPTIONS_FLAG=ON \
            -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
            -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
            -DCOMPILER_RT_BUILD_BUILTINS=ON \
            -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
            -Wno-dev \
            ../llvm"
      system 'ninja'
    end
  end

  def self.install
    Dir.chdir('builddir') do
      system "DESTDIR=#{CREW_DEST_DIR} ninja install"
      FileUtils.install 'clc', "#{CREW_DEST_PREFIX}/bin/clc", mode: 0o755
      FileUtils.install 'clc++', "#{CREW_DEST_PREFIX}/bin/clc++", mode: 0o755
      FileUtils.mkdir_p "#{CREW_DEST_LIB_PREFIX}/bfd-plugins"
      Dir.chdir("#{CREW_DEST_LIB_PREFIX}/bfd-plugins") do
        FileUtils.ln_s "../../lib#{CREW_LIB_SUFFIX}/LLVMgold.so", 'LLVMgold.so'
      end
      # libunwind.* conflicts with libunwind package
      FileUtils.rm Dir.glob("#{CREW_DEST_LIB_PREFIX}/libunwind.*")
    end
  end

  def self.check
    Dir.chdir('builddir') do
      # system "ninja check-llvm || true"
      # system "ninja check-clang || true"
      # system "ninja check-lld || true"
    end
  end

  def self.postinstall
    puts
    puts "To compile programs, use 'clang' or 'clang++'.".lightblue
    puts
    puts 'To avoid the repeated use of switch options,'.lightblue
    puts "try the wrapper scripts 'clc' or 'clc++'.".lightblue
    puts
    puts 'For more information, see http://llvm.org/pubs/2008-10-04-ACAT-LLVM-Intro.pdf'.lightblue
    puts
  end
end
