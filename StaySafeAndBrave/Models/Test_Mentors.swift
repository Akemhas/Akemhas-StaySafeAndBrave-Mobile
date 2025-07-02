//
//  Test_Mentors.swift
//  StaySafeAndBrave
//
//  Created by Sarmiento Castrillon, Clein Alexander on 28.05.25.
// Created initially to test main functionality of Mentorviews without the Backend. It is not being used right now.

import Foundation
import SwiftData

func createMentorSabubona() -> Mentor{
    let name = "Nomusa Ndlela"
    let profile_image = sampleImagesURL.nomusaURL.rawValue // Path to the image
    let score:Float = 4.5
    let birth_date = Date(timeIntervalSinceReferenceDate: -100000000)
    let bio: String = """
Sawubona! Mein Name ist Nomusa Ndlela und ich bin in Kapstadt geboren und aufgewachsen. Ich bin 33 Jahre alt und ich liebe es, dir meine wunderschöne Stadt aus meiner Perspektive zu zeigen. Ich bin ein leidenschaftlicher Local Mentor, die es liebt, anderen Menschen die verschiedenen Kulturen, Geschichten und kulinarischen Genüsse von Kapstadt zu näherzubringen.

Als Tochter eines Zulu-Stammes und einer Xhosa-Mutter wuchs ich in einem multikulturellen Umfeld auf und erhielt früh eine tiefere Perspektive auf die Geschichte und Kultur meiner Heimatstadt. Ich bin stolz darauf, dich mit auf eine Reise durch die Stadt zu nehmen und dir die kulturellen und historischen Hintergründe der verschiedenen Stadtteile zu zeigen. Hierfür biete ich Stadtführungen an. Sprich mich nach deiner Buchung bei Stay Safe & Brave gern darauf an!

Neben meiner Tätigkeit als Local Mentor engagiere ich mich in der Gemeinde und setze mich für die Förderung von Bildung und sozialen Themen ein. In meiner Freizeit treffe ich mich gerne mit Freunden und Familie, probiere neue Restaurants und koche traditionelle Gerichte meiner Kultur.

Ich bin eine offene und freundliche Person und ich freue mich darauf, dich kennenzulernen! Ich bin sicher, dass ich dir einige der versteckten Perlen der Stadt zeigen kann, die in keinem Reiseführer zu finden sind. Willkommen in Kapstadt!
"""
    let languages = [AvailableLanguage.xhosa, AvailableLanguage.afrikaans, AvailableLanguage.english]
    let hobbies = [Hobby.cooking, Hobby.traveling, Hobby.photography]

   return Mentor(timestamp_creation: Date(), id: UUID(), name: name, profile_image: profile_image, score: score, birth_date: birth_date, bio: bio, languages: languages,hobbies: hobbies)
    
}

func createMentorPeter() -> Mentor{
    let name = "Peter van Zyl"
    let profile_image = sampleImagesURL.peterURL.rawValue // Path to the image
    let score:Float = 4.5
    let birth_date = Date(timeIntervalSinceReferenceDate: -1000000000)
    let bio: String = """
Hallo, mein Name ist Pieter van Zyl und ich bin ein waschechter Kapstädter! Ich bin 46 Jahre alt und liebe es, Menschen meine wunderschöne Stadt zu zeigen. Ich bin ein offener und freundlicher Mensch, der gerne Zeit mit anderen verbringt und neue Menschen kennenlernt.

Meine Leidenschaft für Kapstadt begann schon in meiner Kindheit, als ich mit meinen Eltern durch die Stadt spazierte und all die verschiedenen Kulturen und Geschichten kennenlernte. Mit den Jahren habe ich mir ein umfangreiches Wissen über die Geschichte, die Kultur und die Politik von Kapstadt angeeignet.

Als Local Mentor zeige ich dir nicht nur die touristischen Sehenswürdigkeiten, sondern auch die weniger bekannten Orte und Geschichten der Stadt. Ich möchte, dass du Kapstadt so erlebst, wie ich es tue – als eine Stadt voller Vielfalt, Schönheit und Geschichte.

In meiner Freizeit gehe ich gerne wandern oder surfe an den Stränden von Kapstadt. Die Natur und das Meer sind für mich eine Quelle der Ruhe und Entspannung. Ich bin ein Mann mit vielen Facetten, aber meine Liebe zu Kapstadt ist wohl das, was mich am meisten auszeichnet. Auf dem Foto ist übrigens meine Tochter Luisa zu sehen – mein größter Schatz!
"""
    let languages = [AvailableLanguage.afrikaans, AvailableLanguage.english, AvailableLanguage.german]
    let hobbies = [Hobby.reading, Hobby.hiking]

   return Mentor(timestamp_creation: Date(), id: UUID(), name: name, profile_image: profile_image, score: score, birth_date: birth_date, bio: bio, languages: languages,hobbies: hobbies)
    
}

func createMentorLeonie() -> Mentor{
    let name = "Leonie Köster"
    let profile_image = sampleImagesURL.leonieURL.rawValue // Path to the image
    let score:Float = 4.7
    let birth_date = Date(timeIntervalSinceReferenceDate: -1000000000)
    let bio: String = """
Hey, ich bin Leonie und ich bin vor 17 Jahren mit meiner Familie aus Deutschland nach Kapstadt gezogen. Ich bin 27 Jahre alt und ich liebe es, dir Kapstadt aus meiner Sicht zu präsentieren.

Obwohl ich in Deutschland geboren wurde, fühle ich mich Kapstadt tief verbunden und betrachte es als meine zweite Heimat. Ich liebe es, dich auf eine Reise durch die Stadt mitzunehmen und dir die verschiedensten Facetten von Kapstadt zu erklären – von den historischen Straßen von Bo-Kaap bis zu den atemberaubenden Stränden von Clifton.

Ich bin eine offene und freundliche Person und ich freue mich darauf, dich kennenzulernen. Ich bin stolz darauf, Kapstadt zu meiner Heimat gemacht zu haben und ich möchte, dass du die Stadt so erlebst, wie ich sie erlebe – als eine Stadt voller Kontraste und atemberaubender Schönheit.

In meiner Freizeit gehe ich gerne wandern oder verbringe Zeit mit meiner Familie und Freunden. Ich liebe es, neue Restaurants und Cafés zu entdecken und mich von der kulinarischen Vielfalt der Stadt inspirieren zu lassen.

Ich bin sicher, dass ich dir Kapstadt auf eine einzigartige Weise näherbringen kann und ich freue mich darauf, dich bald willkommen zu heißen
"""
    let languages = [AvailableLanguage.german, AvailableLanguage.english]
    let hobbies = [Hobby.reading, Hobby.hiking, Hobby.gaming]

   return Mentor(timestamp_creation: Date(), id: UUID(), name: name, profile_image: profile_image, score: score, birth_date: birth_date, bio: bio, languages: languages,hobbies: hobbies)
    
}


func createMentorTil() -> Mentor{
    let name = "Til Stratmann"
    let profile_image = sampleImagesURL.tilURL.rawValue // Path to the image
    let score:Float = 4
    let birth_date = Date(timeIntervalSinceReferenceDate: -10000000)
    let bio: String = """
Hey, ich bin Til und ich wurde in Greytown, in der Nähe von Durban, geboren. Meine Eltern sind Deutsche und ich bin zweisprachig aufgewachsen. Vor sieben Jahren bin ich für mein Studium nach Johannesburg gezogen und seitdem lebe ich hier.

Johannesburg ist eine Stadt, die mich von Anfang an fasziniert hat. Ich liebe die lebendige Kulturszene und die vielfältigen Möglichkeiten, die die Stadt bietet. Als Local Mentor erkläre ich dir gerne, wo die versteckten Schätze der Stadt liegen – von den Kunstgalerien im hippen Stadtteil Maboneng bis hin zu den historischen Gebäuden in der Innenstadt.

Ich bin ein weltoffener Mensch und liebe es, neue Leute kennenzulernen. Als Sohn von deutschen Eltern fühle ich mich in beiden Kulturen zu Hause und genieße es, diese unterschiedlichen Einflüsse in meinem Leben zu kombinieren. Wenn ich nicht gerade als Local Mentor unterwegs bin, verbringe ich gerne Zeit mit Freunden und Familie oder gehe laufen.

Ich bin sicher, dass ich dir Johannesburg auf eine einzigartige Weise näherbringen kann und ich freue mich darauf, dich bald kennenzulernen!
"""
    let languages = [AvailableLanguage.english, AvailableLanguage.german, AvailableLanguage.zulu]
    let hobbies = [Hobby.reading, Hobby.drawing]
    let city = City.johannesburg

   return Mentor(timestamp_creation: Date(), id: UUID(), name: name, profile_image: profile_image, score: score, birth_date: birth_date, bio: bio, languages: languages,hobbies: hobbies, location: city)
    
}

func createMentorElsabe() -> Mentor{
    let name = "Elsabe Viljoen"
    let profile_image = sampleImagesURL.elsabeURL.rawValue // Path to the image
    let score:Float = 4.9
    let birth_date = Date(timeIntervalSinceReferenceDate: -150000000)
    let bio: String = """
Hi zusammen, ich bin Elsabe und ich bin in Johannesburg geboren und aufgewachsen. Ich bin 31 Jahre alt und ich liebe es, Menschen von Südafrika zu begeistern!

Johannesburg ist eine Stadt voller Kontraste und ich finde es faszinierend, wie sich die Stadt ständig weiterentwickelt. Als Local Mentor zeige ich dir gerne bei unserem Treffen die verschiedenen Seiten der Stadt – von den glitzernden Wolkenkratzern im Finanzviertel bis hin zu den lebendigen Stadtteilen, in denen man traditionelle Gerichte probieren kann.

Ich bin eine neugierige und aufgeschlossene Person und ich liebe es, neue Leute kennenzulernen. Wenn ich nicht gerade als Local Mentor unterwegs bin, verbringe ich gerne Zeit in Cafés und Buchläden oder gehe in einem der vielen Parks der Stadt spazieren.

Ich bin stolz darauf, in Johannesburg zu leben und ich bin sicher, dass ich dir die Stadt auf eine einzigartige Weise näherbringen kann. Egal ob du zum ersten Mal hier bist oder die Stadt schon kennst – ich freue mich darauf, dich in Johannesburg zu treffen und mit dir meine persönlichen Geheimtipps zu teilen!
"""
    let languages = [AvailableLanguage.afrikaans, AvailableLanguage.english, AvailableLanguage.german]
    let hobbies = [Hobby.photography, Hobby.hiking]
    let city = City.johannesburg

   return Mentor(timestamp_creation: Date(), id: UUID(), name: name, profile_image: profile_image, score: score, birth_date: birth_date, bio: bio, languages: languages,hobbies: hobbies, location: city)
    
}

func createMentorZinhle() -> Mentor{
    let name = "Zinhle Ngcobo"
    let profile_image = sampleImagesURL.zinhleURL.rawValue // Path to the image
    let score:Float = 4.8
    let birth_date = Date(timeIntervalSinceReferenceDate: -150000000)
    let bio: String = """
Hey du, ich bin Zinhle und ich komme aus Johannesburg – oder wie ich gerne sage: Joburg, Baby! Ich liebe meine Stadt und ich kann es kaum erwarten, dass du sie auch erleben wirst.

Als Local Mentor bin ich immer für einen Witz oder eine lustige Geschichte zu haben. Ich zeige dir nicht nur, wo die bekannten Sehenswürdigkeiten zu finden sind, sondern auch die geheimen Ecken, die du in keinem Reiseführer findest.

Ich bin eine echte Joburgerin und ich kenne alle coolen Bars, Restaurants und Clubs der Stadt. Ich gebe zu, ich bin ein bisschen verwöhnt, was das angeht, aber ich bin sicher, dass ich auch für dich etwas Passendes finden werde. Wenn du dich für Kultur und Geschichte interessierst, dann habe ich auch ein paar Tricks auf Lager, um dich zu beeindrucken.

Also, worauf wartest du noch? Lass uns in Joburg am Flughafen treffen und eine tolle Zeit zusammen haben!
"""
    let languages = [AvailableLanguage.english, AvailableLanguage.xitsonga, AvailableLanguage.german]
    let hobbies = [Hobby.photography, Hobby.traveling]
    let city = City.johannesburg

   return Mentor(timestamp_creation: Date(), id: UUID(), name: name, profile_image: profile_image, score: score, birth_date: birth_date, bio: bio, languages: languages,hobbies: hobbies, location: city)
    
}

func createMentorLindi() -> Mentor{
    let name = "Lindiwe Khumalo"
    let profile_image = sampleImagesURL.lindiweURL.rawValue // Path to the image
    let score:Float = 5.0
    let birth_date = Date(timeIntervalSinceReferenceDate: -150000000)
    let bio: String = """
Hallo, ich bin Lindiwe und ich bin vor drei Jahren von Port Elizabeth nach Durban gezogen. Ich habe mich sofort in diese Stadt verliebt und kann es kaum erwarten, dir von all meinen Lieblingsorten vorzuschwärmen!

Als Local Mentor finde ich es großartig, Menschen dabei zu helfen, sich in einer neuen Stadt zurechtzufinden. Ich liebe es, neue Leute kennenzulernen und ich bin immer bereit für eine gute Unterhaltung. Wenn ich nicht gerade als Local Mentor arbeite, bin ich oft am Strand oder in einem der vielen Parks von Durban zu finden.

Ich kenne Durban wie meine Westentasche und ich weiß immer, wo man das beste Essen, die besten Cocktails und die beste Live-Musik findet. Ich bin auch sehr stolz auf die Geschichte und Kultur dieser Stadt und ich kann dir viele interessante Fakten und Anekdoten erzählen.

Egal, ob du zum ersten Mal in Südafrika bist oder sogar schon mal hier warst – ich werde dir helfen, das Beste aus deinem Aufenthalt zu machen. Also lass uns connecten und dir einen tollen Südafrika Aufenthalt bereiten!
"""
    let languages = [AvailableLanguage.english, AvailableLanguage.setswana ,AvailableLanguage.german]
    let hobbies = [Hobby.photography, Hobby.hiking]
    let city = City.durban

   return Mentor(timestamp_creation: Date(), id: UUID(), name: name, profile_image: profile_image, score: score, birth_date: birth_date, bio: bio, languages: languages,hobbies: hobbies, location: city)
    
}

func createMentorLaura() -> Mentor{
    let name = "Laura Schrimpf"
    let profile_image = sampleImagesURL.lauraURL.rawValue // Path to the image
    let score:Float = 5.0
    let birth_date = Date(timeIntervalSinceReferenceDate: -150000000)
    let bio: String = """
Hey, ich bin Laura, 30 Jahre alt und ich bin dein Local Mentor in Dortmund! Ursprünglich komme ich aus der Nähe von Hamburg und durchs Studium bin ich vor fünf Jahren nach Dortmund gekommen. Seitdem hat sich meine Liebe zu dieser Stadt entwickelt und so schnell wird mich Dortmund wohl nicht mehr los!

In meinem Leben bin ich schon viel gereist und habe auch schon häufiger eine Zeit im Ausland verbracht. Ich liebe es, neue Länder zu entdecken und neue Menschen aus aller Welt kennenzulernen. Als Local Mentor möchte ich dir nun Dortmund von der besten Seite zeigen! Dortmund hat so viel zu bieten, wovon man zunächst vielleicht gar nicht ausgeht. Ich bin stolz darauf, Dortmund mein Zuhause zu nennen, und ich freue mich darauf, diese Begeisterung mit dir zu teilen.

Nach deiner Buchung melde ich mich bei dir, um alle Fragen rund um deine Reise nach Dortmund zu klären. Ich hole dich an unserem vereinbarten Treffpunkt in Dortmund ab und wir lernen uns bei einem Rundgang durch die Innenstadt besser kennen. Wir werden tolle Foto-Spots finden und die Aussicht vom Dortmunder U über Dortmund genießen. Als Abschluss tauschen wir uns in einem Café/Restaurant/Bar über all die Geheimtipps aus, die ich habe, um deinen Aufenthalt in Dortmund einzigartig zu machen. Du hast nach unserem Treffen noch weitere Fragen? Kein Problem, ich bin immer noch für dich da!

Also, wenn du neugierig auf Dortmund bist und Lust hast, die Stadt mit einem Local zu erkunden, dann begleite mich auf einer Tour durch meine Wahlheimat. Ich freue mich sehr darauf, dich kennenzulernen! Willkommen im Ruhrpott!
"""
    let languages = [AvailableLanguage.german, AvailableLanguage.english]
    let hobbies = [Hobby.traveling, Hobby.photography, Hobby.hiking]
    let city = City.dortmund

   return Mentor(timestamp_creation: Date(), id: UUID(), name: name, profile_image: profile_image, score: score, birth_date: birth_date, bio: bio, languages: languages,hobbies: hobbies, location: city)
    
}


/// Links of the profile pictures available in Sciebo
enum sampleImagesURL: String {
    case nomusaURL = "https://hochschule-rhein-waal.sciebo.de/s/zKzF7MWJatLpR5P/download"
    case peterURL = "https://hochschule-rhein-waal.sciebo.de/s/nAYqHcmd6zFeG5Y/download"
    case leonieURL = "https://hochschule-rhein-waal.sciebo.de/s/85w5NoHwpTaNapP/download"
    case tilURL = "https://hochschule-rhein-waal.sciebo.de/s/G9rBSYn8YcasNm5/download"
    case elsabeURL = "https://hochschule-rhein-waal.sciebo.de/s/pYoq3G8CGJSbb87/download"
    case zinhleURL = "https://hochschule-rhein-waal.sciebo.de/s/7DtWPJR4SpAx6xB/download"
    case lindiweURL = "https://hochschule-rhein-waal.sciebo.de/s/Nz9zgnwDnZntN49/download"
    case thembaURL = "https://hochschule-rhein-waal.sciebo.de/s/JBjmcZ2MEMmobYi/download"
    case hendrikURL = "https://hochschule-rhein-waal.sciebo.de/s/iBKgMPWnKS5q9Nn/download"
    case lauraURL = "https://hochschule-rhein-waal.sciebo.de/s/7MZYqiXA5aQ7mSw/download"
    
}
