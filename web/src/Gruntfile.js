module.exports = function(grunt)
{
    const sass = require("sass");
    require("jit-grunt")(grunt);

    grunt.initConfig({
        sass: {
            development: {
                options: {
                    implementation: sass,
                    sourceMap: false,
                    outputStyle: 'compressed'
                },
                files: {
                    "../public/css/style.css": [
                        "./scss/style.scss"
                    ]
                }
            }
        },
        uglify: {
            build: {
                files: {
                    "../public/js/app.min.js": [
                        "./js/app.js"
                    ]
                }
            }
        },
        htmlmin: {
            build: {
                options: {
                    removeComments: true,
                    collapseWhitespace: true
                },
                files: [{
                    expand: true,
                    cwd: './php/',
                    src: ['**/*.php'],
                    dest: '../public/',
                    filter: 'isFile'
                }]
            }
        },
        watch: {
            scripts: {
                files: ["./js/**/*.js"],
                tasks: ["uglify"],
                options: {
                    nospawn: true
                }
            },
            styles: {
                files: ["./scss/**/*.scss"],
                tasks: ["sass"],
                options: {
                    spawn: true
                }
            },
            docs: {
                files: ["./php/**/*.php"],
                tasks: ["htmlmin"],
                options: {
                    nospawn: true
                }
            }
        }
    });

    grunt.registerTask( "default", ["sass", "uglify", "htmlmin", "watch"] );
};
