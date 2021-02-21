# coding: utf-8
# narzędzie do org postingu na mojej stronce.
# ruby orgise.md forg fin [fout] -- org plik forg zmienia
# w html i dodaje do pliku fin w miejscu oznaczonym znacznikiem,
# a następnie zapisuje w fout (jeśli nie podane, to overwrites fin)

# zapewne nie w dobrym smaku rubiowym bo to moduł powinien być
# a nie skrypt głupi, ale nie umiem ruby xdd


require 'org-ruby'
require 'htmlbeautifier'

class ExcludedPost < StandardError
end

def parsuj(org)
  rules = "tags.yml"
  p = Orgmode::Parser.new(org, { markup_file: rules,  use_sub_superscripts: false})
  # use_sub_superscripts nie umiem opcji wyłączyć,
  # więc ją zakomentowałem w source kodzie org-ruby xd
  date = ""
  title = ""
  ident = ""
  exclude = false
  p.in_buffer_settings.each do |set, val|
    if set.downcase == "date" then
      date = val
    elsif set.downcase == "title" then
      title = val
    elsif set.downcase == "ident" then
      ident = val
    elsif set.downcase == "exclude" or set.downcase == "excluded" and
         val.downcase == "true" then
      exclude = true
    end
  end
  if exclude then raise ExcludedPost end
  if title == "" then raise("no title mate") end
  if date != "" then
    html_date = "<div class=\"date_wrap\">" + "<span id=\"datka\">" +
                date + "</span>\n" + "</div>\n"
  else
    html_date = ""
  end
  if ident == "" then ident = title.dup end
  # extra latex tagss
  remph = /\\emph\{((.|\n)+?)\}/
  rextsc = /\\textsc\{((.|\n)+?)\}/
  reqed = /\\qed\{((.|\n)+?)\}/
  p = p.to_html
  p.gsub! remph, '<span class="emph">\1</span>'
  p.gsub! rextsc, '<span class="textsc">\1</span>'
  p.gsub! reqed, '<p class="qed">\1</p>'
  return html_date + p, ident, title
end

def linkise(post)
  post.gsub! "href", "id=\"linek\" href"
end

def make_postorg(org)
  html, id, titl = parsuj(org)
  id.gsub! " ", "-"
  linkise(html)
  if html.nil? then raise("nil html??") end
  res = ["<div class=\"text\" id=\"" + id + "\">\n" + html + "\n</div>" +
         " <!-- fin_post_" + id + " -->",
         (Regexp.new "<div class=\"text\" id=\"" + Regexp.escape(id) +
                     "\">(.|\n)*</div>(\s|\n)*" +
                     Regexp.escape(" <!-- fin_post_" + id + " -->")),
         titl]
  return res
end

def make_post(fname)
  file = File.open(fname)
  org = file.read
  post, beg_re, titl = make_postorg(org)
  return post, beg_re, titl
end

# Find the word 'like'
"Do you like cats?" =~ /like/

def is_end(page)
  where = page =~ /<!--END_KURDE-->/
  if where.nil? then raise("no end marking") end
end

def insert_post(post, page)
  _ENDOFPAGE = nil
  where = page =~ /<!--END_KURDE-->/
  page.insert(where, post + "\n")
end


def read_page(page)
  file = File.open(page)
  page = file.read
  return page
end

def orgise(forg, page, newp, edit=true)
  is_end(page)
  post, beg_re, titl = make_post(forg)
  if edit then
    if !(page =~ beg_re).nil? then
      puts ("edition of a post at " + (page =~ beg_re).to_s)
      page.gsub! beg_re, post
    else
      insert_post(post, page)
    end
  else
    insert_post(post, page)
  end
  if newp then page.gsub! "___szablon___", titl end
  beautiful = HtmlBeautifier.beautify(page)
  return beautiful
end

def file_orgise(forg, path, path_out, edit, newp)
  page = read_page(path)
  beautiful = orgise(forg, page, newp, edit)
  File.write(path_out, beautiful)
end
  
def main_orgise
  puts "* ---- ORGISE ---- *"
  if ARGV.length == 0 then raise("specify [org_file] and [page_file]") end
  forg = ARGV[0]
  if ARGV.length < 2 then
    raise("specify the html out file!")
  else
    path = ARGV[1]
    # output file and "-n" flag mess
    if ARGV.length >= 3 then
      if ARGV.length >= 4 then        
        path_out = ARGV[2]
        edit = ARGV[3] != "-n"
      elsif ARGV[2] != "-n" and ARGV[2] != "--newp" then
        path_out = ARGV[1]
        edit = true
      else
        path_out = path
        edit = false        
      end
    else
      path_out = path
      edit = true
    end
  end
  newp = ARGV[ARGV.length - 1] == "--newp"
  begin
    file_orgise(forg, path, path_out, edit, newp)
    puts forg + " --> "+ path_out
    puts "* ---- THUS CONCLUDING THE ORGISATION ---- *"
  rescue ExcludedPost
    puts forg + " is excluded"
    return
  end

end

main_orgise
