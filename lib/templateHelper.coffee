fs = require("fs")
path = require("path")
argv = require("yargs").argv

paths =
  src: "src"
  dest: "dist"

revvedFile = (filePath) ->
  revs = try
    require("./../#{paths.dest}/rev-manifest.json")
  catch
    undefined
  file = if revs then revs[filePath] else filePath

isEnglish = (filePath) ->
  (context) ->
    if filePath and filePath.match(/^pages\/(contact|articles)/)
      true
    else
      context.mvb?.article?.lang is "en"

getDate = (article) ->
  if article.updated?
    new Date(Date.parse(article.updated))
  else
    article.date

module.exports =
  createHelper: (file, isDev, baseUrl, assetHost) ->
    filePath = path.relative(paths.src, file.path)
    isElm = filePath.match(/^(pages\/(articles|artikel)\/elm)/) || filePath.match(/^articles\/elm/)

    {
      baseUrl: (filePath) ->
        if !filePath.match(/^https?:/)
          baseUrl + filePath
        else
          fileePath

      assetUrl: (filePath, includeHost = true) ->
        filePath = revvedFile(filePath)
        "#{if includeHost then assetHost else ''}/#{filePath}"

      assetInline: (filePath) ->
        filePath = "./#{paths.dest}/#{revvedFile(filePath)}"
        content = fs.readFileSync(filePath, "utf8")
        content

      isEnglish: isEnglish(filePath)
      isDev: isDev

      nav:
        isHome: filePath.match(/^pages\/index/)
        isContact: filePath.match(/^pages\/(contact|kontakt)/)
        isProjects: filePath.match(/^pages\/(projects|projekte)/)
        isArticles: filePath.match(/^(pages\/(articles|artikel)|articles\/|drafts\/)/) && !isElm
        isElm: isElm

      article:
        feedDate: (a) ->
          getDate(a).toISOString()
        germanDate: (a) ->
          a.date.toISOString().replace(/T.*/, "").split("-").reverse().join(".")
        englishDate: (a) ->
          a.date.toString().replace(/\w+\s(\w+)\s(\d+)\s(\d+).*/, "$1 $2, $3")
        description: (a) ->
          a.description or a.content.replace(/(<([^>]+)>)/ig, "").substring(0, 150)
        keywords: (a) ->
          a.tags.join(',')
        hasCode: (a) ->
          !!a.content.match(/class="(hljs|lang-).*"/)

      articles:
        feedDate: (articles) ->
          dates = articles.map((article)-> getDate(article))
          latestUpdate = new Date(Math.max.apply(null, dates))
          latestUpdate.toISOString()
        filterByNoAlternate: (articles, lang) ->
          articles.filter (article) ->
            alternate = article.alternate
            !alternate or alternate.lang isnt lang
        filterByLanguage: (articles, lang) ->
          articles.filter (article) ->
            article.lang is lang

      lang: (context) ->
        if isEnglish(filePath)(context) then "en" else "de"

      t: (context, g, e) ->
        if isEnglish(filePath)(context) then e else g
    }
