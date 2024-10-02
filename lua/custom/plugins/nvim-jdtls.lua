return {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    config = function()
        local jdtls = require 'jdtls'

        local home = os.getenv 'HOME'
        local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
        local workspace_dir = workspace_path .. project_name

        local os_config = 'mac'

        local bundles = {}

        vim.list_extend(bundles, vim.split(vim.fn.glob '/Users/samhren/Code/debug/vscode-java-test/server/*.jar', '\n'))

        vim.list_extend(bundles, vim.split(vim.fn
                                               .glob '/Users/samhren/Code/debug/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
            '\n'))

        local extendedClientCapabilities = jdtls.extendedClientCapabilities
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local config = {
            cmd = {'java', '-Declipse.application=org.eclipse.jdt.ls.core.id1', '-Dosgi.bundles.defaultStartLevel=4',
                   '-Declipse.product=org.eclipse.jdt.ls.core.product', '-Dlog.protocol=true', '-Dlog.level=ALL',
                   '-Xms1g', '--add-modules=ALL-SYSTEM', '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                   '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                   '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar', '-jar',
                   vim.fn
                .glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
                   '-configuration', home .. '/.local/share/nvim/mason/packages/jdtls/config_' .. os_config, '-data',
                   workspace_dir},
            root_dir = require('jdtls.setup').find_root {'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'},

            settings = {
                java = {
                    eclipse = {
                        downloadSources = true
                    },
                    configuration = {
                        updateBuildConfiguration = 'interactive',
                        runtimes = {{
                            name = 'JavaSE-17',
                            path = '~/.sdkman/candidates/java/17.0.12-oracle'
                        }}
                    },
                    maven = {
                        downloadSources = true
                    },
                    referencesCodeLens = {
                        enabled = true
                    },
                    references = {
                        includeDecompiledSources = true
                    },
                    inlayHints = {
                        parameterNames = {
                            enabled = 'all' -- literals, all, none
                        }
                    },
                    format = {
                        enabled = false
                    }
                },
                signatureHelp = {
                    enabled = true
                },
                extendedClientCapabilities = extendedClientCapabilities
                -- extendedClientCapabilities = {
                --   stopOnExit = false,
                -- },
            },
            init_options = {
                bundles = bundles
            }
        }

        vim.api.nvim_create_autocmd({'BufWritePost'}, {
            pattern = {'*.java'},
            callback = function()
                local _, _ = pcall(vim.lsp.codelens.refresh)
            end
        })

        config['on_attach'] = function(client, bufnr)
            local _, _ = pcall(vim.lsp.codelens.refresh)
            require('jdtls').setup_dap {
                hotcodereplace = 'auto'
            }
        end, require('jdtls').start_or_attach(config)
    end
}
