part of golf_handicap; 
 
// lib/gen/golf/handicap/courses.dart 
 
abstract class CourseGen extends ConceptEntity<Course> { 
 
  CourseGen(Concept concept) : super.of(concept) { 
    Concept teeConcept = concept.model.concepts.singleWhereCode("Tee"); 
    setChild("courseTees", new Tees(teeConcept)); 
  } 
 
  CourseGen.withId(Concept concept, String name) : super.of(concept) { 
    setAttribute("name", name); 
    Concept teeConcept = concept.model.concepts.singleWhereCode("Tee"); 
    setChild("courseTees", new Tees(teeConcept)); 
  } 
 
  String get name => getAttribute("name"); 
  set name(String a) => setAttribute("name", a); 
  
  String get address => getAttribute("address"); 
  set address(String a) => setAttribute("address", a); 
  
  String get zipPostalCode => getAttribute("zipPostalCode"); 
  set zipPostalCode(String a) => setAttribute("zipPostalCode", a); 
  
  String get country => getAttribute("country"); 
  set country(String a) => setAttribute("country", a); 
  
  String get state => getAttribute("state"); 
  set state(String a) => setAttribute("state", a); 
  
  String get websiteUrl => getAttribute("websiteUrl"); 
  set websiteUrl(String a) => setAttribute("websiteUrl", a); 
  
  String get locationUrl => getAttribute("locationUrl"); 
  set locationUrl(String a) => setAttribute("locationUrl", a); 
  
  String get phoneNumber => getAttribute("phoneNumber"); 
  set phoneNumber(String a) => setAttribute("phoneNumber", a); 
  
  Tees get courseTees => getChild("courseTees"); 
  
  Course newEntity() => new Course(concept); 
  Courses newEntities() => new Courses(concept); 
  
  int nameCompareTo(Course other) { 
    return name.compareTo(other.name); 
  } 
 
} 
 
abstract class CoursesGen extends Entities<Course> { 
 
  CoursesGen(Concept concept) : super.of(concept); 
 
  Courses newEntities() => new Courses(concept); 
  Course newEntity() => new Course(concept);
  
} 
 
