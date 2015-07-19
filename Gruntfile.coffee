module.exports = (grunt) ->
    'use strict'

    require('load-grunt-tasks')(grunt)

    grunt.initConfig {
        pkg: grunt.file.readJSON 'package.json'
        banner: """

        /**
         * <%= pkg.name %>
         * Version: <%= pkg.version %>
         * Copyright 2015 - <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>
         */
         
        """
        clean: {
            build: ['build']
            tmp: ['.tmp']
        }
        less: {
            compileCore: {
                options: {
                    strictMath: true,
                    sourceMap: true,
                    outputSourceFiles: true,
                    sourceMapURL: '<%= pkg.name %>.css.map'
                    sourceMapFilename: '.tmp/build/css/<%= pkg.name %>.css.map'
                }
                files: {
                    '.tmp/build/css/<%= pkg.name %>.css': 'src/less/style.less'
                }
            }
        }
        cssmin: {
            options: {
                keepSpecialComments: '*'
                noAdvanced: true
            }
            core: {
                files: {
                    '.tmp/build/css/<%= pkg.name %>.css': '.tmp/build/css/<%= pkg.name %>.css'
                }
            }
        }
        usebanner: {
            dist: {
                options: {
                    position: 'top'
                    banner: '<%= banner %>'
                }
                files: {
                    src: [
                        '.tmp/build/css/<%= pkg.name %>.css'
                    ]
                }
            }
        }
        copy: {
            js: {
                expand: true
                cwd: "src/"
                src: ["js/**/*.js"]
                dest: ".tmp/build/"
            }
            module: {
                expand: true
                cwd: "src/"
                src: ["module/**/*.js"]
                dest: ".tmp/build/"
            }
            img: {
                expand: true
                cwd: "src/"
                src: ["img/**"]
                dest: ".tmp/build/"
            }
            data: {
                expand: true
                cwd: "src/"
                src: ["data/**"]
                dest: ".tmp/build/"
            }
            bower: {
                expand: true
                cwd: "bower_components/"
                src: ["**/*"]
                dest: ".tmp/build/vendor/"
            }
            view: {
                expand: true
                cwd: "view/"
                src: ["**"]
                dest: "build/"
            }
            build: {
                expand: true
                cwd: ".tmp/build/"
                src: ["**"]
                dest: "build/"
            }
        }
        uglify: {
            options: {
                mangle: {
                    except: ['require']
                }
                normalizeDirDefines: true
                skipDirOptimize: false
                banner: '<%= banner %>'
                preserveComments: 'some'
            }
            js: {
                files: [{
                    expand: true
                    cwd: ".tmp/build/"
                    src: ["js/**/*.js", "module/**/*.js"]
                    dest: "build/"
                }]
            }
        }
        connect: {
            options: {
                port: 9009
                livereload: 42202
                hostname: 'localhost'
                base: '.'
                middleware: (connect, options, middlewares) ->
                    middlewares.unshift (req, res, next) ->
                        req.url = "/index.html" if req.url is "/"
                        if req.url.indexOf("http://") isnt -1
                            return next()
                        # if req.url.indexOf(".json") isnt -1
                        #     return next()
                        if req.url.indexOf("vendor") isnt -1
                            req.url = "/.tmp/build" + req.url
                            return next()
                        if req.url.indexOf("build") isnt -1
                            return next()
                        if req.url.indexOf(".html") isnt -1
                            req.url = "/view" + req.url
                            return next()
                        req.url = "/.tmp/build" + req.url
                        return next()
                    return middlewares
            }
            livereload: {
                options: {
                    open: {
                        target: "http://localhost:9009/index.html"
                    }
                }
            }
        }
        # excel_vocabulary: {
        #     options: {
        #         beautify: true
        #     }
        #     files: {
        #         # expand: true,
        #         cwd: 'src/data',
        #         dest: 'src/data',
        #         src: [
        #          '**/*.xlsx'
        #         ],
        #         ext: '.json'
        #     }
              
        # },
        watch: {
            less: {
                files: 'src/less/**/*.less'
                tasks: ['less']
            }
            js: {
                files: 'src/js/**/*.js'
                tasks: ['copy:js']
            }
            img: {
                files: 'src/img/**'
                tasks: ['copy:img']
            }
            data: {
                files: 'src/data/**'
                tasks: ['copy:data']
            }
            module: {
                files: 'src/module/**'
                tasks: ['copy:module']
            }
            livereload: {
                options: {
                    livereload: '<%= connect.options.livereload %>'
                }
                files: [
                    '{,*/}*.html'
                    '.tmp/build/**/css/{,*/}*.css'
                    '.tmp/build/**/js/{,*/}*.js'
                    '.tmp/build/**/module/**'
                    '.tmp/build/**/img/**'
                ]
            }
        }
        'string-replace': {
            dist: {
                files: [{
                    expand: true
                    cwd: "build/"
                    src: "**/*.html"
                    dest: "build/"
                },{
                    expand: true
                    cwd: "build/js/"
                    src: "**/*.js"
                    dest: "build/js/"
                }]
                options: {
                    replacements: [{
                        pattern: /localhost:9009/ig,
                    }]
                }
            }
        }
    }

    grunt.registerTask 'servebuild', [
        'clean:tmp'
        'copy:js'
        'copy:module'
        'copy:img'
        'copy:data'
        'copy:bower'
        'less'
    ]

    grunt.registerTask 'build', [
        'clean:*'                       #Clean .tmp && build folder
        'less', 'cssmin', 'usebanner'   #Build Css
        # 'excel_vocabulary'
        'copy:*'
        'uglify:js'                     #Uglify JS
        'string-replace'                #HTML localhost replacement
    ]

    grunt.registerTask 'serve', ['servebuild', 'connect:livereload', 'watch']

    grunt.registerTask 'server', ['serve']

    grunt.registerTask 'default', ['serve']

    return
