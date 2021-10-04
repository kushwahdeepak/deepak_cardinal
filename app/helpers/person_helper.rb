module PersonHelper
   class CandidateRankClassifier

    def self.classify_rank params
      r_val = ""
      SCHOOL_SYNONYMS.each do |k|
        if params[:school]&.include? k
          r_val = Person::TOP_SCHOOL_TAG + ' '
          break
        end
      end
      UNICORN_COMPANIES.each do |c|
        if params[:company_names]&.include? c
          r_val += Person::TOP_COMPANY_TAG + ' '
          break
        end
        if params[:resume_text]&.include? c
          r_val += Person::TOP_COMPANY_TAG + ' '
          break
        end
      end
      TOP_INTERNET_COMPANIES.each do |c|
        break if r_val.include? Person::TOP_COMPANY_TAG
        if params[:company_names]&.include? c
          r_val += Person::TOP_COMPANY_TAG+ ' '
          break
        end
        if params[:resume_text]&.include? c
          r_val += Person::TOP_COMPANY_TAG + ' '
          break
        end
      end
      if r_val.present?
        r_val += Person::TOP_2O_PERCENT_TAG + ' '
        Rails.logger.debug("candidate #{params[:email_address]} identified as top20persent")
      end
      r_val.strip
    end

    UNICORN_COMPANIES=["Bytedance", "Didi Chuxing", "SpaceX", "Stripe", "Kuaishou", "Instacart", "Epic Games", "One97 Communications", 
      "Yuanfudao", "DJI Innovations", "SHEIN", "Chime", "Grab", "Samumed", "JUUL Labs", "Bitmain Technologies", "BYJU's", "Manbang Group", 
      "Robinhood", "Global Switch", "Klarna", "UiPath", "Gojek", "Nubank", "Ripple", "Aurora", "Roivant Sciences", "Coupang", "Tanium", 
      "Chehaoduo", "Tempus", "Coinbase", "OYO Rooms", "SenseTime", "Argo AI", "Tokopedia", "Discord", "Automation Anywhere", "Ziroom", 
      "Snapdeal", "National Stock Exchange of India", "Compass", "Magic Leap", "Ola Cabs", "Fanatics", "Databricks", "Royole Corporation", 
      "Canva", "Easyhome", "Lianjia", "Vice Media", "We Doctor", "Revolut", "Checkout.com", "Samsara Networks", "HashiCorp", "OneTrust", 
      "United Imaging Healthcare", "TransferWise", "UBTECH Robotics", "Procore", "Hello TransTech", "Krafton Game Union", "WM Motor", 
      "Nuro", "Toast", "SoFi", "Meizu Technology", "VIPKid", "Confluent", "Marqeta", "Bolt", "Ginkgo BioWorks", "Klaviyo", "Yello Mobile", 
      "MEGVII", "Greensill", "Roblox", "TripActions", "Impossible Foods", "Xingsheng Selected", "Better.com", "Niantic", "GoPuff", "Zomato", 
      "Houzz", "Intarcia Therapeutics", "Gusto", "Swiggy", "Northvolt", "Auto1 Group", "Otto Bock HealthCare", "Deliveroo", "Indigo Ag", 
      "SouChe Holdings", "Discord", "Freshworks", "Rappi", "N26", "Rivian", "HyalRoute", "Bukalapak", "Scale AI", "Youxia Motors", "Rubrik", 
      "Scopely", "Dadi Cinema", "Oscar Health", "Flexport", "Cloudwalk", "Udemy", "SentinelOne", "VANCL", "Automattic", "Warby Parker", 
      "Yixia", "Xiaohongshu", "Traveloka", "Katerra", "reddit", "BGL Group", "Circle Internet Financial", "Pony.ai", "Talkdesk", "Brex", 
      "Netskope", "Horizon Robotics", "Wildlife Studios", "MessageBird", "Affirm", "Ovo", "Waterdrop", "Meicai", "OakNorth", "DataRobot", 
      "Bird Rides", "GitLab", "Convoy", "Sprinklr", "Zhihu", "Toss", "Snyk", "Xinchao Media", "Airtable", "23andMe", "Vista Global", "BYTON", 
      "Cohesity", "Celonis", "Aihuishou", "Dream11", "Coursera", "Cazoo", "Faire", "Cgtz", "Carbon", "Duolingo", "Collibra", "WEMAKEPRICE", 
      "Uptake", "Udaan", "Skydance Media", "Relativity Space", "ReNew Power", "HEYTEA", "Zume", "FlixBus", "Via Transportation", 
      "Oxford Nanopore Technologies", "NuCom Group", "Checkr", "Gong", "Attentive Mobile", "HuiMin", "Huaqin Telecom Technology", 
      "YITU Technology", "Hopin", "Nextdoor", "Zenefits", "Trendy Group International", "Tubatu.com", "Quanergy Systems", "AppLovin", "Quora", 
      "Improbable", "Preferred Networks", "Zuoyebang", "LegalZoom", "4Paradigm", "Kaseya", "Tongdun Technology", "Mafengwo", "Babylon Health", 
      "Next Insurance", "Figma", "Dingdong Maicai", "Postman", "Oatly", "Tipalti", "Unqork", "Unacademy", "AppsFlyer", "Calm", "Pine Labs", "ISN", 
      "ThoughtSpot", "Graphcore", "Auth0", "Avant", "InVision", "BillDesk", "eDaili", "monday.com", "Anduril", "RigUp", "MUSINSA", "Devoted Health", 
      "Airwallex", "AIWAYS", "GetYourGuide", "ZocDoc", "Farmers Business Network", "GOAT", "Creditas", "Apus Group", "XANT", "Buzzfeed", "Thumbtack", 
      "Squarespace", "Allbirds", "PAX", "Carta", "Blend", "BlaBlaCar", "Darktrace", "ServiceTitan", "Zhubajie", "Infinidat", "Afiniti", "Dataminr", 
      "Jusfoun Big Data", "sweetgreen", "Seismic", "Zhangmen", "Pine Labs", "Verkada", "ASR Microelectronics", "Promasidor Holdings", "Monzo", 
      "CAOCAO", "Ximalaya FM", "ironSource", "Mofang Living", "Gett", "Cybereason", "Lalamove", "Changingedu", "XiaoZhu", "HeartFlow", 
      "JOLLY Information Technology", "Yijiupi", "Cambridge Mobile Telematics", "Delhivery", "wefox Group", "PolicyBazaar", "Remitly", "Hippo", 
      "Lenskart", "ACV Auctions", "Podium", "ApplyBoard", "Ro", "Mirakl", "Olive", "Strava", "DT Dream", "ENOVATE", "Koudai", "TuJia", "Coocaa", 
      "Hike", "Symphony", "Yidian Zixun", "Cabify", "Hive Box", "Deezer", "Away", "Dataiku", "Voodoo", "Klook", "Rippling", "Outreach", "GPclub", 
      "Grove Collaborative", "Docker", "Zeta Global", "OrCam Technologies", "Sonder", "Trax", "Knotel", "You & Mr Jones", "InSightec", "Gymshark", 
      "Arctic Wolf Networks", "Forter", "EverlyWell", "Starry", "Lookout", "Intercom", "OVO Energy", "WTOIP", "BrewDog", "Medlinker", "ezCater", 
      "Applied Intuition", "AvidXchange", "GalaxySpace", "OfferUp", "Yiguo", "Fair", "Glossier", "KeepTruckin", "Zipline International", "SmartNews", 
      "Figure Technologies", "Rapyd", "VAST Data", "Workhuman", "FiveTran", "Qumulo", "Patreon", "dLocal", "Greenlight", "Dialpad", "Whoop", 
      "L&P Cosmetic", "Unisound", "Illumio", "Luoji Siwei", "Yimidida", "Tuhu", "Lyell Immunopharma", "LifeMiles", "Kavak", "DigitalOcean", 
      "Venafi", "Doctolib", "Deposit Solutions", "Vinted", "TELD", "TangoMe", "HuJiang", "OVH", "Just", "Tradeshift", "Coveo", "Sisense", 
      "Course Hero", "Sema4", "Lyra Health", "Pharmapacks", "Virta Health", "LinkDoc Technology", "Biren Techonology", "Nxin", "Rubicon Global", 
      "Rivigo", "Jiuxian", "Tresata", "Linklogis", "Zymergen", "AppDirect", "Radius Payment Solutions", "Aprogen", "YH Global", "Miaoshou Doctor", 
      "Leap Motor", "InMobi", "Mu Sigma", "TechStyle Fashion Group", "LinkSure Network", "Red Ventures", "BeiBei", "BenevolentAI", "FXiaoKe", 
      "Vox Media", "Mia.com", "Womai", "58 Daojia", "iTutorGroup", "MindMaze", "iCarbonX", "Age of Learning", "SMS Assist", "Kendra Scott", 
      "Rocket Lab", "Zhuan Zhuan", "Zhaogang", "DianRong", "Cell C", "Revolution Precrafted", "WeLab", "Maimai", "Payoneer", "Rani Therapeutics", 
      "Dxy.cn", "100credit", "SoundHound", "Orbbec Technology", "Huike Group", "OutSystems", "China Cloud", "Kuaigou Dache", "MediaMath", 
      "Pat McGrath Labs", "Wacai", "About You", "Tuya Smart", "Formlabs", "FlashEx", "Branch", "Banma Network Technologies", "ZipRecruiter", 
      "Momenta", "Hosjoy", "Omio", "TERMINUS Technology", "BitFury", "WalkMe", "iFood", "Geek+", "Globality", "TuSimple", "OCSiAl", "Rent the Runway", 
      "Intellifusion", "Liquid", "Sila Nanotechnologies", "Poizon", "BigBasket", "VTS", "Ivalua", "KnowBox", "Loggi", "Yanolja", "Gympass", "KnowBe4", 
      "Meero", "Druva", "StockX", "Ola Electric Mobility", "Turo", "Icertis", "Lightricks", "Ibotta", "C2FO", "Numbrs", "QuintoAndar", "CMR Surgical", 
      "Acronis", "Dave", "Grammarly", "EBANX", "Pendo", "Instabase", "KK Group", "Kujiale", "Vacasa", "Riskified", "Guild Education", "Bright Health", 
      "Glovo", "Loft", "HighRadius", "ClassPass", "Alto Pharmacy", "FirstCry", "Flywire", "Emerging Markets Property Group", "o9 Solutions", "Quizlet", 
      "Keep", "Amplitude", "Apeel Sciences", "Lilium Aviation", "Orca Bio", "Upgrade", "KKW Beauty", "VillageMD", "Thrasio", "Trumid", "Innovium", 
      "Infobip", "Redis Labs", "Mollie", "Zwift", "Playco", "Razorpay", "Socar", "Tekion", "Eightfold.ai", "Gousto", "Cato Networks", "Chainalysis", 
      "Cars24", "Cityblock Health", "ClickUp", "Zenoti", "BigID", "Boom Supersonic", "AInnovation", "Qualia", "Ant Financial", "DiDi", "Lufax", 
      "Cainiao", "Paytm", "DJI", "Jiedaibao", "OYO", "Byju's", "WeBank", "OneConnect", "JD Finance", "WeWork", "Farfetch", "Samsara", "CloudKitchens", 
      "Bluehole", "Meizu", "BAIC BJEV", "Megvii", "Ginkgo Bioworks", "UBtech Robotics", "Opendoor", "Garena", "Shouqi Car Rental", "The Hut Group", 
      "Credit Karma", "e-Shang Redwood", "Zoox", "Zerodha", "VIPKID", "AliMusic", "Jia.com", "LY.com", "Meili United Group", "Wanda E-commerce", 
      "Yixia Technology", "OVO", "UnionPay", "Bird", "Viva Republica", "Plaid", "AmWINS Group", "Woowa Brothers", "Cambricon", "Kingsoft Cloud", 
      "Mozido", "Wemakeprice", "Babytree", "Three Squirrels", "FlixMobility", "Applovin", "Beijing Weiying Technology", "Firstp2p", "Huimin.cn", 
      "Meicai.cn", "Maoyan-Weiying", "Sensetime", "Taopiaopiao", "Trendy International Group", "Youxinpai", "Yinlong Group", "Sanpower Group", 
      "Monday.com", "Dfinity", "Prosper Marketplace", "Peak Games", "Musinsa", "Postmates", "Avito.ru", "Billdesk", "Ucommune", "Crystal Lagoons", 
      "NantOmics", "Reddit", "Zocdoc", "PAX Labs", "Taihe Music Group", "The Honest Company", "Caocao Zhuanche", "Seismic Software", 
      "Proteus Digital Health", "Spring Rain Software", "Douyu TV", "Lakala", "Ninebot", "Souche", "UCloud", "Tujia.com", "ZBJ.com", "Letgo", 
      "VNG", "Hellobike", "Suning Sports", "Tuandaiwang", "Koudai Gouwu", "Hike Messenger", "GPClub", "ETCP", "Kr Space", "Alisports", "Loji Logistics", 
      "Iwjw", "Kyriba", "Bigbasket", "Bitmain", "Byton", "EasyLife Financial Services", "Dada", "NetEase Cloud Music", "Wheels Up", "NetEase Youdao", 
      "Global Fashion Group", "Hims & Hers", "Ualá", "IronSource", "Frontline Education", "Shape Security", "Age of Learning, Inc.", "Branch Metrics", 
      "Policy Bazaar", "Pine Lab", "JD Indonesia", "Beibei", "Chubao Technology", "Dt Dream", "DXY", "Futu Securities", "Fangdd.com", "Fanli", 
      "Huikedu Group", "Innovent Biologics", "JFrog", "Jiangsu Zimi Technology", "Jollychic", "Lamabang", "Careem", "MissFresh", "Mobvoi", 
      "Mofang Apartment", "Novogene", "QingCloud", "Smartmi", "Wacai.com", "Wifi Master Key", "Xiaozhu.com", "Yitu Technology", "Essential Products", 
      "Zhaogang.com", "Zhuanzhuan", "17Zuoye", "GoGoVan", "36Kr Media", "Lookout Security", "Kabam", "9fbank.com", "Udacity", "MedMen", "OrCam", 
      "One Medical", "Nearmap", "Content Square", "Prometheus Group", "team.blue", "CitiusTech", "Ola Electric", "Lucid Software", "Octopus Energy", 
      "Arctic Wolf", "EMPG", "Pipedrive", "Alan", "Algolia", "ASAPP", "Bright Machines", "Cameo", "Capsule", "Citizen", "Cockroach Labs", "Codemao", 
      "Covariant", "CRED", "Culture Amp", "CurrencyCloud", "Dashlane", "Divvy", "Doctor On Demand", "Flutterwave", "Frame.io", "Harness", "Ironclad", 
      "Loom", "Luminar Technologies", "Mercury", "Moglix", "Moveworks", "Omada Health", "Personio", "PlayVS", "SafetyCulture", "Sendbird", "Sennder", 
      "Sentry", "Signavio", "Slice", "Tessian", "Thought Machine", "Tink", "Tray.io", "Uala", "Vedantu Innovations", "Webflow"]

    TOP_INTERNET_COMPANIES = ["Amazon", "Google", "JD.com", "Facebook", "Alibaba", "Tencent", "Suning.com", "Netflix", "ByteDance", "PayPal", 
      "Salesforce.com", "Baidu", "Booking", "Uber", "Meituan-Dianping", "Expedia", "Rakuten", "Adobe", "eBay", "Bloomberg L.P.", "Wayfair", "NetEase", 
      "Zalando", "Kuaishou", "Spotify", "Coupang", "Flipkart", "Naver", "Epic Games", "Trip.com", "Chewy", "Airbnb", "Square", "Pinduoduo", 
      "Sabre Corporation", "Carvana", "Bet365", "Workday", "Lyft", "ServiceNow", "Twitter", "Stripe", "ASOS.com", "GoDaddy", "Akamai Technologies", 
      "Yandex", "Zillow", "Kakao", "The Stars Group", "Travelport", "Wirecard", "Fanatics", "EPAM Systems", "58.com", "Groupon", "Rocket Internet", 
      "Sea Limited", "Sina Corp", "B2W", "Newegg", "Match Group", "Copart", "Instacart", "Shutterfly", "Wish", "Sohu", "Snap", "Rackspace", "Dropbox", 
      "Shopify", "Stitch Fix", "TripAdvisor", "Kaplan, Inc.", "Mail.Ru", "Overstock", "ANGI Homeservices Inc.", "Zynga", "LogMeIn", "Grubhub", 
      "J2 Global", "Verisign", "Pinterest", "Twilio", "Endurance International Group", "Farfetch", "Yelp", "Vroom.com", "Craigslist", "DocuSign", 
      "Ultimate Software", "Grab"]

    SCHOOL_SYNONYMS = ["Princeton University", "Harvard University", "Columbia University", "Massachusetts Institute of Technology", 
    "Yale University", "Stanford University", "University of Chicago", "University of Pennsylvania", "California Institute of Technology", 
    "Johns Hopkins University", "Northwestern University", "Duke University", "Dartmouth College", "Brown University", "Vanderbilt University", 
    "Rice University", "Washington University in St. Louis", "Cornell University", "University of Notre Dame", "University of California--Los Angeles", 
    "Emory University", "University of California--Berkeley", "Georgetown University", "University of Michigan--Ann Arbor", 
    "University of Southern California", "Carnegie Mellon University", "University of Virginia", "University of North Carolina--Chapel Hill", 
    "Wake Forest University", "New York University", "Tufts University", "University of California--Santa Barbara", "University of Florida", 
    "University of Rochester", "Boston College", "Georgia Institute of Technology", "University of California--Irvine", 
    "University of California--San Diego", "University of California--Davis", "William & Mary", "Tulane University", "Boston University", 
    "Brandeis University", "Case Western Reserve University", "University of Texas at Austin", "University of Wisconsin--Madison", 
    "University of Georgia", "University of Illinois--Urbana-Champaign", "Lehigh University", "Northeastern University", "Pepperdine University", 
    "University of Miami", "Ohio State University--Columbus", "Purdue University--West Lafayette", "Rensselaer Polytechnic Institute", 
    "Santa Clara University", "Villanova University", "Florida State University", "Syracuse University", "University of Maryland--College Park", 
    "University of Pittsburgh--Pittsburgh Campus", "University of Washington", "Pennsylvania State University--University Park", 
    "Rutgers University--New Brunswick", "University of Connecticut", "Fordham University", "George Washington University", 
    "Loyola Marymount University", "Southern Methodist University", "Texas A&M University", "University of Massachusetts--Amherst", 
    "University of Minnesota--Twin Cities", "Worcester Polytechnic Institute", "Clemson University", "Virginia Tech", "American University", 
    "Baylor University", "Indiana University--Bloomington", "Yeshiva University", "Brigham Young University--Provo", "Gonzaga University", 
    "Howard University", "Michigan State University", "North Carolina State University", "Stevens Institute of Technology", 
    "Texas Christian University", "University of Denver", "Binghamton University--SUNY", "Colorado School of Mines", "Elon University", 
    "Marquette University", "Stony Brook University--SUNY", "University at Buffalo--SUNY", "University of California--Riverside", 
    "University of Iowa", "University of San Diego", "Auburn University", "University of Arizona", "University of California--Merced", 
    "University of California--Santa Cruz", "University of Delaware", "University of Utah", "Arizona State University--Tempe", "Clark University", 
    "Miami University--Oxford", "Saint Louis University", "Temple University", "University of Colorado Boulder", "University of Oregon", 
    "University of San Francisco", "University of South Florida", "Creighton University", "Loyola University Chicago", 
    "Rochester Institute of Technology", "University of Illinois--Chicago", "University of Tennessee", "Iowa State University", 
    "New Jersey Institute of Technology", "Rutgers University--Newark", "SUNY College of Environmental Science and Forestry", 
    "University of South Carolina", "University of Vermont", "Chapman University", "Clarkson University", "DePaul University", "Drake University", 
    "Gallaudet University", "Illinois Institute of Technology", "Seattle University", "University of Kansas", "University of Missouri", 
    "Drexel University", "The New School", "Seton Hall University", "Simmons University", "University of Dayton", "University of Kentucky", 
    "University of Nebraska--Lincoln", "University of Oklahoma", "University of St. Thomas (MN)", "University of the Pacific", 
    "The Catholic University of America", "Duquesne University", "George Mason University", "Samford University", "San Diego State University", 
    "University of Alabama", "University of Cincinnati", "University of New Hampshire", "University of Texas at Dallas", "University of Tulsa", 
    "Colorado State University", "Louisiana State University--Baton Rouge", "Michigan Technological University", "Oregon State University", 
    "Quinnipiac University", "Rutgers University--Camden", "University of Alabama at Birmingham", "Belmont University", "Hofstra University", 
    "Mercer University", "University at Albany--SUNY", "University of Arkansas", "University of Central Florida", 
    "University of Maryland--Baltimore County", "University of Mississippi", "Valparaiso University", "Virginia Commonwealth University", 
    "Adelphi University", "Kansas State University", "St. John's University (NY)", "University of Hawaii--Manoa", "University of Idaho", 
    "University of Rhode Island", "CUNY--City College", "Missouri University of Science and Technology", "Montclair State University", 
    "Ohio University", "St. John Fisher College", "Thomas Jefferson University", "University of Houston", "University of Louisville", 
    "University of Massachusetts--Lowell", "University of St. Joseph", "Washington State University", "Biola University", "Chatham University", 
    "Florida International University", "Oklahoma State University", "Pacific University", "Rowan University", "University of Detroit Mercy", 
    "University of New Mexico", "University of North Carolina--Wilmington", "Bethel University (MN)", "California State University--Fresno", 
    "Indiana University-Purdue University--Indianapolis", "Loyola University New Orleans", "Maryville University of St. Louis", 
    "Robert Morris University"]
  end




  def user_has_no_note?(user)
    user.notes.blank?
  end

  def linkedin_profile_position
    @person = Person.find(params[:id])
    @linkedin_profile_position = LinkedinProfilePosition.where(id: @person.linkedin_profile_position_id).first
  end

  # def user_has_no_save?(save)
  #   user.saves.blank?
  # end
end
