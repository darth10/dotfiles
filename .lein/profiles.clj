{:user {:plugins
        [[lein-ancient "0.6.15"]
         [lein-exec "0.3.7"]
         [lein-pprint "1.3.2"]
         [lein-try "0.4.3"]
         [http-kit/lein-template "1.0.0-SNAPSHOT"]
         [chestnut/lein-template "0.18.0"]
         [compojure-app/lein-template "0.4.9"]]}
 :repl {:plugins
        [[refactor-nrepl "2.5.0"]
         [cider/cider-nrepl "0.25.4"]]
        :dependencies
        [[org.clojure/tools.nrepl "0.2.13"]
         [compliment "0.3.11"]]}}
