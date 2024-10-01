<h2 align="center">
  <img src="README_images/SyntHIR_logo.PNG" height="150px">
</h2>

<h4 align="center">
    Accelerating translation from clinical research to tools
</h4>

## FHIR Adapter:

This adapter component is used to upload and download FHIR resources to and from a FHIR server. Steps to configure:

#### Step 1. Create a FHIR server instance called 'Azure API for FHIR' on Microsoft Azure.

Follow the below steps:

1.  Register on the Azure portal using your email ID (https://portal.azure.com/)

2.  Using Azure portal, create and deploy a service 'Azure API for FHIR'. Follow the link https://learn.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/fhir-paas-portal-quickstart. Make note of the FHIR endpoint and add in the key name 'synthir.hdl.fhir.server.base.url' in the configuration file (in the project source code src/main/resources/application-prod.properties).

#### Step 2. Setup 'Microsoft Entra ID' for identity and access management of the resources on Azure

Follow the below steps:

1.  Create a tenant in the Microsoft Entra ID using the link: https://learn.microsoft.com/en-us/entra/fundamentals/create-new-tenant.

2.  Make note of tenant ID which tenant ID used by component for generating access token to access the resources on the FHIR server and add in the key name 'azure.active.directory.tenant.id' in the configuration file (in the project source code src/main/resources/application-prod.properties).

#### Step 3. Register an application to access the FHIR resources

Follow the below steps:

1.  Register an application in the tenant created in the above step (2) using the link: https://learn.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/register-confidential-azure-ad-client-app. Make note of the following details needed by the application configuration file (in the project source code src/main/resources/application-prod.properties) of the component:

    1. Application(client) ID of the application registered and add in the key name 'synthir.app.client.reg.id'

    2. Client secret value and add in the key name 'synthir.app.client.reg.secret.value'.

#### Step 4. Grant access to application registered in step 3 for accessing the data on FHIR server created in step 1

Follow the below steps:

1.  Next, grant access to the application registered as the 'FHIR Data Conrtibutor' for accessing the data on FHIR server(Azure API for FHIR) using assign roles instructions in the link: https://learn.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/configure-azure-rbac.

## Getting Started

If you want to just run the FHIR Adapter component, should follow the [Run the component using Docker image](#run-the-component-using-docker-image) instructions instead, and to examine or extend the source code, follow [Developer Start Guide](#developer-start-guide) instructions.

### [Run the component using Docker image](#run-the-component-using-docker-image)

The docker image of the component is uploaded on the DockerHub, and docker file is also available in the root directory of the project source code (named as Dockerfile), which needs to be build into a image. The docker image can run on the local machine or on 'play with docker' (https://www.docker.com/play-with-docker/).

To run the dockerfile on the local machine, install docker desktop on windows, linux or mac using the link : https://docs.docker.com/get-docker/. Pull the docker image from docker hub and run it OR Use the dockerfile available in the source code.

To use the docker image from docker hub, pull and run:

```
docker pull synthir21/fhir_adapter:latest
docker run -p 1234:8081 fhir_adapter:latest
```

To use the dockerfile available in the source code, first clone the repository:

```
git clone https://github.com/synthir/fhir-adapter.git
cd fhir-adpater
```

Now, build docker image from the dockerfile and run:

```
docker build --tag 'fhir_adapter:latest' .
docker run -p 1234:8082 fhir_adapter:latest
```

Argument --tag indicates the repository name for the image (fhir_adapter) and tag is latest; 8082 is the port number on which the application is running in the container and 1234 is the port number mapped to 8082 port of the container.

### [Developer Start Guide](#developer-start-guide)

These instructions are intended for those who want to examine the source code, extend it or build the code locally.

**System Requirements:** Data Wrangling component requires Java JDK 17 or newer (JDK download link: https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html).To clone the repository:

```
git clone https://github.com/synthir/fhir-adapter.git
cd fhir-adpater
```

**Component Configuration:** Update the component configuration file(in the project source code src/main/resources/application-prod.properties)::

```
  azure.active.directory.tenant.id (Refer to above steps)
  synthir.fhir.server.base.url (Refer to above steps)
  synthir.app.client.reg.id (Refer to above steps)
  synthir.app.client.reg.secret.value (Refer to above steps)
  server.port=XXXX (Port on which the application will run)
```

**Build and run the component**

```

mvnw clean
mvnw install
mvnw spring-boot:run

```

After running the component, the API can called be called using the hostname:portname followed by the API URL

## Dataset

A sample dataset used for the development of the SyntHIR system is available at https://dataverse.no/dataset.xhtml?persistentId=doi:10.18710/YABAGM

## API details

1.  Upload to FHIR server

    1. Request URL: http://hostname:port-number/api/v1/fhir-server/upload?fhirServerUrl=xxxxxx
    2. Request Type: POST
    3. Request param: fhirServerUrl (with the URL of the FHIR server on which data is to be uploaded)
    4. Request Body: Will be a list of JSON objects. Sample of JSON response is below:

    ```json
    [
      {
        "patient": {
          "resourceType": "Patient",
          "identifier": [
            {
              "use": "temp",
              "system": null,
              "value": "34579"
            }
          ],
          "name": null,
          "gender": "female",
          "birthDate": "1921",
          "deceasedBoolean": false,
          "deceasedDateTime": "2013-02",
          "address": [
            {
              "use": "",
              "city": "Hordaland Fylkeskommune",
              "district": "",
              "state": "",
              "postalCode": "12",
              "country": "Norway"
            }
          ],
          "extension": [
            {
              "valueString": "6"
            }
          ]
        },
        "practitioner": {
          "resourceType": "Practitioner",
          "identifier": [
            {
              "use": "temp",
              "system": null,
              "value": "42293"
            }
          ],
          "name": null,
          "gender": "male",
          "birthDate": "1952"
        },
        "location": {
          "resourceType": "Location",
          "identifier": null,
          "name": "Helse Bergen HF Haukeland",
          "mode": null,
          "address": null
        },
        "condition": {
          "resourceType": "Condition",
          "identifier": null,
          "code": {
            "coding": [
              {
                "code": "I49",
                "system": "http://hl7.org/fhir/sid/icd-10",
                "display": null
              }
            ],
            "text": "ICD-10 Codes"
          },
          "subject": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Patient associated with the condition",
            "type": "Patient"
          },
          "encounter": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Encounter associated with Patient",
            "type": "Encounter"
          }
        },
        "encounter": {
          "resourceType": "Encounter",
          "identifier": null,
          "status": "finished",
          "type": null,
          "subject": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Patient Hospitalized",
            "type": "Patient"
          },
          "location": [
            {
              "location": {
                "reference": "",
                "identifier": {
                  "use": null,
                  "system": null,
                  "value": ""
                },
                "display": "Institute Name where prescribed",
                "type": "Location"
              },
              "status": null
            }
          ],
          "hospitalization": {
            "dischargeDisposition": {
              "coding": [
                {
                  "code": "Other",
                  "system": "http://terminology.hl7.org/CodeSystem/discharge-disposition",
                  "display": null
                }
              ],
              "text": "Others"
            }
          },
          "period": {
            "start": "8/14/2013",
            "end": "8/14/2013"
          },
          "diagnosis": null,
          "participant": [
            {
              "individual": {
                "reference": "",
                "identifier": {
                  "use": null,
                  "system": null,
                  "value": ""
                },
                "display": "Practitioner Details for the patient hospitalized",
                "type": "Practitioner"
              }
            }
          ],
          "class": {
            "code": "PRENC",
            "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
            "display": "Patient arrival mode for the Encounter"
          }
        },
        "medication": {
          "resourceType": "Medication",
          "identifier": [
            {
              "use": null,
              "system": null,
              "value": "267967"
            }
          ],
          "code": {
            "coding": [
              {
                "code": "C01AA04",
                "system": "http://www.whocc.no/atc",
                "display": null
              }
            ],
            "text": "Digimerck pico tab 0,05mg"
          }
        },
        "medicationRequest": {
          "resourceType": "MedicationRequest",
          "identifier": [
            {
              "use": null,
              "system": null,
              "value": "61526227"
            }
          ],
          "status": "unknown",
          "intent": "option",
          "category": [
            {
              "coding": [
                {
                  "code": "",
                  "system": null,
                  "display": null
                }
              ],
              "text": "BlÃ¥reseptordningen Â§Â§ 2, 3a, 3b, 4 og 5 (gammel ordning Â§Â§ 2, 3, 4, 9, og 10a)"
            }
          ],
          "medicationReference": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Medications for the prescription",
            "type": "Medication"
          },
          "subject": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Patient for the prescription",
            "type": "Patient"
          },
          "encounter": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Encounter associated with the prescription",
            "type": "Encounter"
          },
          "recorder": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Practitioner who prescribed the prescription",
            "type": "Practitioner"
          },
          "note": [
            {
              "authorString": "Legal Reimbursement category for the prescription",
              "text": "3"
            },
            {
              "authorString": "Legal Reimbursement code for the prescription",
              "text": "6"
            },
            {
              "authorString": "Reimbursement code for the prescription - ICD/ICPC",
              "text": "ICPC:K77"
            }
          ],
          "dosageInstruction": [
            {
              "text": "Defined daily dose of the drug",
              "doseAndRate": [
                {
                  "doseQuantity": {
                    "value": 0.1,
                    "unit": "mg"
                  },
                  "rateQuantity": {
                    "value": 0.0,
                    "unit": "Per Day"
                  }
                }
              ]
            }
          ]
        },
        "medicationDispense": {
          "resourceType": "MedicationDispense",
          "status": "unknown",
          "medicationReference": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Medication details for the dispense",
            "type": "Medication"
          },
          "subject": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Patient for the\r\nprescription",
            "type": "Patient"
          },
          "authorizingPrescription": [
            {
              "reference": "",
              "identifier": {
                "use": null,
                "system": null,
                "value": ""
              },
              "display": "Prescription for the Medication",
              "type": "MedicationRequest"
            }
          ],
          "quantity": {
            "value": 0.01,
            "unit": null
          },
          "daysSupply": {
            "value": 0.5,
            "unit": null
          },
          "whenHandedOver": "5/12/2014"
        }
      },
      {
        "patient": {
          "resourceType": "Patient",
          "identifier": [
            {
              "use": "temp",
              "system": null,
              "value": "34579"
            }
          ],
          "name": null,
          "gender": "female",
          "birthDate": "1921",
          "deceasedBoolean": false,
          "deceasedDateTime": "2013-02",
          "address": [
            {
              "use": "",
              "city": "Hordaland Fylkeskommune",
              "district": "",
              "state": "",
              "postalCode": "12",
              "country": "Norway"
            }
          ],
          "extension": [
            {
              "valueString": "6"
            }
          ]
        },
        "practitioner": {
          "resourceType": "Practitioner",
          "identifier": [
            {
              "use": "temp",
              "system": null,
              "value": "42293"
            }
          ],
          "name": null,
          "gender": "male",
          "birthDate": "1952"
        },
        "location": {
          "resourceType": "Location",
          "identifier": null,
          "name": "Helse Bergen HF Haukeland",
          "mode": null,
          "address": null
        },
        "condition": {
          "resourceType": "Condition",
          "identifier": null,
          "code": {
            "coding": [
              {
                "code": "I49",
                "system": "http://hl7.org/fhir/sid/icd-10",
                "display": null
              }
            ],
            "text": "ICD-10 Codes"
          },
          "subject": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Patient associated with the condition",
            "type": "Patient"
          },
          "encounter": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Encounter associated with Patient",
            "type": "Encounter"
          }
        },
        "encounter": {
          "resourceType": "Encounter",
          "identifier": null,
          "status": "finished",
          "type": null,
          "subject": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Patient Hospitalized",
            "type": "Patient"
          },
          "location": [
            {
              "location": {
                "reference": "",
                "identifier": {
                  "use": null,
                  "system": null,
                  "value": ""
                },
                "display": "Institute Name where prescribed",
                "type": "Location"
              },
              "status": null
            }
          ],
          "hospitalization": {
            "dischargeDisposition": {
              "coding": [
                {
                  "code": "Other",
                  "system": "http://terminology.hl7.org/CodeSystem/discharge-disposition",
                  "display": null
                }
              ],
              "text": "Others"
            }
          },
          "period": {
            "start": "8/14/2013",
            "end": "8/14/2013"
          },
          "diagnosis": null,
          "participant": [
            {
              "individual": {
                "reference": "",
                "identifier": {
                  "use": null,
                  "system": null,
                  "value": ""
                },
                "display": "Practitioner Details for the patient hospitalized",
                "type": "Practitioner"
              }
            }
          ],
          "class": {
            "code": "PRENC",
            "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
            "display": "Patient arrival mode for the Encounter"
          }
        },
        "medication": {
          "resourceType": "Medication",
          "identifier": [
            {
              "use": null,
              "system": null,
              "value": "85944"
            }
          ],
          "code": {
            "coding": [
              {
                "code": "N02BE01",
                "system": "http://www.whocc.no/atc",
                "display": null
              }
            ],
            "text": "Panodil tab 1g"
          }
        },
        "medicationRequest": {
          "resourceType": "MedicationRequest",
          "identifier": [
            {
              "use": null,
              "system": null,
              "value": "54953344"
            }
          ],
          "status": "unknown",
          "intent": "option",
          "category": [
            {
              "coding": [
                {
                  "code": "",
                  "system": null,
                  "display": null
                }
              ],
              "text": "Normalresepter"
            }
          ],
          "medicationReference": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Medications for the prescription",
            "type": "Medication"
          },
          "subject": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Patient for the prescription",
            "type": "Patient"
          },
          "encounter": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Encounter associated with the prescription",
            "type": "Encounter"
          },
          "recorder": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Practitioner who prescribed the prescription",
            "type": "Practitioner"
          },
          "note": [
            {
              "authorString": "Legal Reimbursement category for the prescription",
              "text": "7"
            },
            {
              "authorString": "Legal Reimbursement code for the prescription",
              "text": ""
            },
            {
              "authorString": "Reimbursement code for the prescription - ICD/ICPC",
              "text": "ICPC:"
            }
          ],
          "dosageInstruction": [
            {
              "text": "Defined daily dose of the drug",
              "doseAndRate": [
                {
                  "doseQuantity": {
                    "value": 3.0,
                    "unit": "g"
                  },
                  "rateQuantity": {
                    "value": 0.0,
                    "unit": "Per Day"
                  }
                }
              ]
            }
          ]
        },
        "medicationDispense": {
          "resourceType": "MedicationDispense",
          "status": "unknown",
          "medicationReference": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Medication details for the dispense",
            "type": "Medication"
          },
          "subject": {
            "reference": "",
            "identifier": {
              "use": null,
              "system": null,
              "value": ""
            },
            "display": "Patient for the\r\nprescription",
            "type": "Patient"
          },
          "authorizingPrescription": [
            {
              "reference": "",
              "identifier": {
                "use": null,
                "system": null,
                "value": ""
              },
              "display": "Prescription for the Medication",
              "type": "MedicationRequest"
            }
          ],
          "quantity": {
            "value": 0.14,
            "unit": null
          },
          "daysSupply": {
            "value": 4.667,
            "unit": null
          },
          "whenHandedOver": "4/7/2014"
        }
      }
    ]
    ```

    5. Response Body: success if data is uploaded successfully

2.  Download from FHIR server

    1. Request URL: http://hostname:port-number/api/v1/fhir-server/download?fhirServerUrl=xxxxxx
    2. Request Type: GET
    3. Request param: fhirServerUrl (with the URL of the FHIR server on which data is to be downloaded)
    4. Response Body: Will be a list of JSON objects. Example of JSON is given below:

    ```json
    [
      {
        "patient": {
          "resourceType": "Patient",
          "id": "9dbcfce2-2c3a-476a-9b39-eead46d3c725",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:13.987+00:00"
          },
          "identifier": [
            {
              "use": "temp",
              "system": null,
              "value": "34940"
            }
          ],
          "active": false,
          "name": null,
          "gender": "female",
          "birthDate": "1941",
          "deceasedBoolean": false,
          "deceasedDateTime": null,
          "address": [
            {
              "use": null,
              "city": "Hordaland Fylkeskommune",
              "district": null,
              "state": null,
              "postalCode": "12",
              "country": "Norway"
            }
          ],
          "extension": [
            {
              "valueString": "3"
            }
          ]
        },
        "practitioner": {
          "resourceType": "Practitioner",
          "id": "6f8f2364-e104-47e6-a98d-3614e9d5337d",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:14.824+00:00"
          },
          "identifier": [
            {
              "use": "temp",
              "system": null,
              "value": "44260"
            }
          ],
          "active": false,
          "name": null,
          "gender": "female",
          "birthDate": "1954"
        },
        "location": {
          "resourceType": "Location",
          "id": "e1318990-70da-46ba-bc24-508b4c8b5332",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:15.288+00:00"
          },
          "identifier": null,
          "status": null,
          "name": "Helse Bergen HF Haukeland",
          "mode": null,
          "address": null
        },
        "condition": {
          "resourceType": "Condition",
          "id": "dd1641fb-2c01-4a92-85f8-61bfe6ef6bbe",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:15.763+00:00"
          },
          "identifier": null,
          "category": null,
          "code": {
            "coding": [
              {
                "code": "D11",
                "system": "http://hl7.org/fhir/sid/icd-10",
                "display": null
              }
            ],
            "text": "ICD-10 Codes"
          },
          "subject": {
            "reference": "Patient/9dbcfce2-2c3a-476a-9b39-eead46d3c725",
            "identifier": {
              "use": null,
              "system": null,
              "value": "9dbcfce2-2c3a-476a-9b39-eead46d3c725"
            },
            "display": "Patient associated with the condition",
            "type": "Patient"
          },
          "encounter": {
            "reference": "Encounter/0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d",
            "identifier": {
              "use": null,
              "system": null,
              "value": "0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d"
            },
            "display": "Encounter associated with Patient",
            "type": "Encounter"
          }
        },
        "encounter": {
          "resourceType": "Encounter",
          "id": "0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:15.506+00:00"
          },
          "extension": null,
          "identifier": null,
          "status": "finished",
          "type": null,
          "subject": {
            "reference": "Patient/9dbcfce2-2c3a-476a-9b39-eead46d3c725",
            "identifier": {
              "use": null,
              "system": null,
              "value": "9dbcfce2-2c3a-476a-9b39-eead46d3c725"
            },
            "display": "Patient Hospitalized",
            "type": "Patient"
          },
          "location": [
            {
              "location": {
                "reference": "Location/e1318990-70da-46ba-bc24-508b4c8b5332",
                "identifier": {
                  "use": null,
                  "system": null,
                  "value": "e1318990-70da-46ba-bc24-508b4c8b5332"
                },
                "display": "Institute Name where prescribed",
                "type": "Location"
              },
              "status": null
            }
          ],
          "hospitalization": {
            "dischargeDisposition": {
              "coding": [
                {
                  "code": "Other",
                  "system": "http://terminology.hl7.org/CodeSystem/discharge-disposition",
                  "display": null
                }
              ],
              "text": "Others"
            }
          },
          "period": {
            "start": "2012-12-07",
            "end": "2012-12-07"
          },
          "participant": [
            {
              "individual": {
                "reference": "Practitioner/6f8f2364-e104-47e6-a98d-3614e9d5337d",
                "identifier": {
                  "use": null,
                  "system": null,
                  "value": "6f8f2364-e104-47e6-a98d-3614e9d5337d"
                },
                "display": "Practitioner Details for the patient hospitalized",
                "type": "Practitioner"
              }
            }
          ],
          "class": {
            "code": "PRENC",
            "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
            "display": "Patient arrival mode for the Encounter"
          }
        },
        "medication": {
          "resourceType": "Medication",
          "id": "1de886f3-2471-4825-9e2a-1931580fc2d0",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:15.993+00:00"
          },
          "identifier": [
            {
              "use": null,
              "system": null,
              "value": "5390"
            }
          ],
          "code": {
            "coding": [
              {
                "code": "R03BB01",
                "system": "http://www.whocc.no/atc",
                "display": null
              }
            ],
            "text": "Atrovent inh aer 20mcg/dose ff"
          }
        },
        "medicationRequest": {
          "resourceType": "MedicationRequest",
          "id": "18be387f-5343-4fba-9890-2f61101280c6",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:16.184+00:00"
          },
          "identifier": [
            {
              "use": null,
              "system": null,
              "value": "50442198"
            }
          ],
          "status": "unknown",
          "intent": "option",
          "category": [
            {
              "coding": [
                {
                  "code": "3",
                  "system": null,
                  "display": null
                }
              ],
              "text": "Blåreseptordningen §§ 2, 3a, 3b, 4 og 5 (gammel ordning §§ 2, 3, 4, 9, og 10a)"
            }
          ],
          "medicationReference": {
            "reference": "Medication/1de886f3-2471-4825-9e2a-1931580fc2d0",
            "identifier": {
              "use": null,
              "system": null,
              "value": "1de886f3-2471-4825-9e2a-1931580fc2d0"
            },
            "display": "Medications for the prescription",
            "type": "Medication"
          },
          "subject": {
            "reference": "Patient/9dbcfce2-2c3a-476a-9b39-eead46d3c725",
            "identifier": {
              "use": null,
              "system": null,
              "value": "9dbcfce2-2c3a-476a-9b39-eead46d3c725"
            },
            "display": "Patient for the prescription",
            "type": "Patient"
          },
          "encounter": {
            "reference": "Encounter/0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d",
            "identifier": {
              "use": null,
              "system": null,
              "value": "0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d"
            },
            "display": "Encounter associated with the prescription",
            "type": "Encounter"
          },
          "recorder": {
            "reference": "Practitioner/6f8f2364-e104-47e6-a98d-3614e9d5337d",
            "identifier": {
              "use": null,
              "system": null,
              "value": "6f8f2364-e104-47e6-a98d-3614e9d5337d"
            },
            "display": "Practitioner who prescribed the prescription",
            "type": "Practitioner"
          },
          "note": [
            {
              "authorString": "Legal Reimbursement category for the prescription",
              "text": "§ 2 Forhåndsgodkjent refusjon (tidligere § 9)"
            },
            {
              "authorString": "Legal Reimbursement code for the prescription",
              "text": "7"
            },
            {
              "authorString": "Reimbursement code for the prescription - ICD/ICPC",
              "text": "ICPC:R95"
            }
          ],
          "dosageInstruction": [
            {
              "text": "Defined daily dose of the drug",
              "doseAndRate": [
                {
                  "doseQuantity": {
                    "value": 0.12,
                    "unit": "mg"
                  },
                  "rateQuantity": {
                    "value": 0.0,
                    "unit": "Per Day"
                  }
                }
              ]
            }
          ]
        },
        "medicationDispense": {
          "resourceType": "MedicationDispense",
          "id": "5c5ff711-0cf7-469d-a9e2-4baf8f6cc16f",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:16.319+00:00"
          },
          "status": "unknown",
          "medicationReference": {
            "reference": "Medication/1de886f3-2471-4825-9e2a-1931580fc2d0",
            "identifier": {
              "use": null,
              "system": null,
              "value": "1de886f3-2471-4825-9e2a-1931580fc2d0"
            },
            "display": "Medication details for the dispense",
            "type": "Medication"
          },
          "subject": {
            "reference": "Patient/9dbcfce2-2c3a-476a-9b39-eead46d3c725",
            "identifier": {
              "use": null,
              "system": null,
              "value": "9dbcfce2-2c3a-476a-9b39-eead46d3c725"
            },
            "display": "Patient for the prescription",
            "type": "Patient"
          },
          "authorizingPrescription": [
            {
              "reference": "MedicationRequest/18be387f-5343-4fba-9890-2f61101280c6",
              "identifier": {
                "use": null,
                "system": null,
                "value": "18be387f-5343-4fba-9890-2f61101280c6"
              },
              "display": "Prescription for the Medication",
              "type": "MedicationRequest"
            }
          ],
          "quantity": {
            "value": 3000.0,
            "unit": null
          },
          "daysSupply": {
            "value": 100000.0,
            "unit": null
          },
          "whenHandedOver": null
        }
      },
      {
        "patient": {
          "resourceType": "Patient",
          "id": "9dbcfce2-2c3a-476a-9b39-eead46d3c725",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:13.987+00:00"
          },
          "identifier": [
            {
              "use": "temp",
              "system": null,
              "value": "34940"
            }
          ],
          "active": false,
          "name": null,
          "gender": "female",
          "birthDate": "1941",
          "deceasedBoolean": false,
          "deceasedDateTime": null,
          "address": [
            {
              "use": null,
              "city": "Hordaland Fylkeskommune",
              "district": null,
              "state": null,
              "postalCode": "12",
              "country": "Norway"
            }
          ],
          "extension": [
            {
              "valueString": "3"
            }
          ]
        },
        "practitioner": {
          "resourceType": "Practitioner",
          "id": "6f8f2364-e104-47e6-a98d-3614e9d5337d",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:14.824+00:00"
          },
          "identifier": [
            {
              "use": "temp",
              "system": null,
              "value": "44260"
            }
          ],
          "active": false,
          "name": null,
          "gender": "female",
          "birthDate": "1954"
        },
        "location": {
          "resourceType": "Location",
          "id": "e1318990-70da-46ba-bc24-508b4c8b5332",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:15.288+00:00"
          },
          "identifier": null,
          "status": null,
          "name": "Helse Bergen HF Haukeland",
          "mode": null,
          "address": null
        },
        "condition": {
          "resourceType": "Condition",
          "id": "dd1641fb-2c01-4a92-85f8-61bfe6ef6bbe",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:15.763+00:00"
          },
          "identifier": null,
          "category": null,
          "code": {
            "coding": [
              {
                "code": "D11",
                "system": "http://hl7.org/fhir/sid/icd-10",
                "display": null
              }
            ],
            "text": "ICD-10 Codes"
          },
          "subject": {
            "reference": "Patient/9dbcfce2-2c3a-476a-9b39-eead46d3c725",
            "identifier": {
              "use": null,
              "system": null,
              "value": "9dbcfce2-2c3a-476a-9b39-eead46d3c725"
            },
            "display": "Patient associated with the condition",
            "type": "Patient"
          },
          "encounter": {
            "reference": "Encounter/0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d",
            "identifier": {
              "use": null,
              "system": null,
              "value": "0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d"
            },
            "display": "Encounter associated with Patient",
            "type": "Encounter"
          }
        },
        "encounter": {
          "resourceType": "Encounter",
          "id": "0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:15.506+00:00"
          },
          "extension": null,
          "identifier": null,
          "status": "finished",
          "type": null,
          "subject": {
            "reference": "Patient/9dbcfce2-2c3a-476a-9b39-eead46d3c725",
            "identifier": {
              "use": null,
              "system": null,
              "value": "9dbcfce2-2c3a-476a-9b39-eead46d3c725"
            },
            "display": "Patient Hospitalized",
            "type": "Patient"
          },
          "location": [
            {
              "location": {
                "reference": "Location/e1318990-70da-46ba-bc24-508b4c8b5332",
                "identifier": {
                  "use": null,
                  "system": null,
                  "value": "e1318990-70da-46ba-bc24-508b4c8b5332"
                },
                "display": "Institute Name where prescribed",
                "type": "Location"
              },
              "status": null
            }
          ],
          "hospitalization": {
            "dischargeDisposition": {
              "coding": [
                {
                  "code": "Other",
                  "system": "http://terminology.hl7.org/CodeSystem/discharge-disposition",
                  "display": null
                }
              ],
              "text": "Others"
            }
          },
          "period": {
            "start": "2012-12-07",
            "end": "2012-12-07"
          },
          "participant": [
            {
              "individual": {
                "reference": "Practitioner/6f8f2364-e104-47e6-a98d-3614e9d5337d",
                "identifier": {
                  "use": null,
                  "system": null,
                  "value": "6f8f2364-e104-47e6-a98d-3614e9d5337d"
                },
                "display": "Practitioner Details for the patient hospitalized",
                "type": "Practitioner"
              }
            }
          ],
          "class": {
            "code": "PRENC",
            "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
            "display": "Patient arrival mode for the Encounter"
          }
        },
        "medication": {
          "resourceType": "Medication",
          "id": "1118d953-3ef4-4a19-8ba7-8c5366b9a389",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:16.925+00:00"
          },
          "identifier": [
            {
              "use": null,
              "system": null,
              "value": "3988"
            }
          ],
          "code": {
            "coding": [
              {
                "code": "M01AB05",
                "system": "http://www.whocc.no/atc",
                "display": null
              }
            ],
            "text": "Voltaren enterotab 50mg"
          }
        },
        "medicationRequest": {
          "resourceType": "MedicationRequest",
          "id": "cfb938a1-5e95-44b0-9ac7-a59ce2d7d318",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:17.113+00:00"
          },
          "identifier": [
            {
              "use": null,
              "system": null,
              "value": "59750864"
            }
          ],
          "status": "unknown",
          "intent": "option",
          "category": [
            {
              "coding": [
                {
                  "code": "3",
                  "system": null,
                  "display": null
                }
              ],
              "text": "Blåreseptordningen §§ 2, 3a, 3b, 4 og 5 (gammel ordning §§ 2, 3, 4, 9, og 10a)"
            }
          ],
          "medicationReference": {
            "reference": "Medication/1118d953-3ef4-4a19-8ba7-8c5366b9a389",
            "identifier": {
              "use": null,
              "system": null,
              "value": "1118d953-3ef4-4a19-8ba7-8c5366b9a389"
            },
            "display": "Medications for the prescription",
            "type": "Medication"
          },
          "subject": {
            "reference": "Patient/9dbcfce2-2c3a-476a-9b39-eead46d3c725",
            "identifier": {
              "use": null,
              "system": null,
              "value": "9dbcfce2-2c3a-476a-9b39-eead46d3c725"
            },
            "display": "Patient for the prescription",
            "type": "Patient"
          },
          "encounter": {
            "reference": "Encounter/0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d",
            "identifier": {
              "use": null,
              "system": null,
              "value": "0e5b5fdd-b3a1-40cb-b8eb-e17c6c97c41d"
            },
            "display": "Encounter associated with the prescription",
            "type": "Encounter"
          },
          "recorder": {
            "reference": "Practitioner/6f8f2364-e104-47e6-a98d-3614e9d5337d",
            "identifier": {
              "use": null,
              "system": null,
              "value": "6f8f2364-e104-47e6-a98d-3614e9d5337d"
            },
            "display": "Practitioner who prescribed the prescription",
            "type": "Practitioner"
          },
          "note": [
            {
              "authorString": "Legal Reimbursement category for the prescription",
              "text": "§ 2 Forhåndsgodkjent refusjon (tidligere § 9)"
            },
            {
              "authorString": "Legal Reimbursement code for the prescription",
              "text": "7"
            },
            {
              "authorString": "Reimbursement code for the prescription - ICD/ICPC",
              "text": "ICPC:L88"
            }
          ],
          "dosageInstruction": [
            {
              "text": "Defined daily dose of the drug",
              "doseAndRate": [
                {
                  "doseQuantity": {
                    "value": 0.1,
                    "unit": "g"
                  },
                  "rateQuantity": {
                    "value": 0.0,
                    "unit": "Per Day"
                  }
                }
              ]
            }
          ]
        },
        "medicationDispense": {
          "resourceType": "MedicationDispense",
          "id": "5e0afecc-86c5-4850-b85c-be496aa9c739",
          "meta": {
            "profile": null,
            "versionId": "1",
            "lastUpdated": "2023-06-05T22:03:17.227+00:00"
          },
          "status": "unknown",
          "medicationReference": {
            "reference": "Medication/1118d953-3ef4-4a19-8ba7-8c5366b9a389",
            "identifier": {
              "use": null,
              "system": null,
              "value": "1118d953-3ef4-4a19-8ba7-8c5366b9a389"
            },
            "display": "Medication details for the dispense",
            "type": "Medication"
          },
          "subject": {
            "reference": "Patient/9dbcfce2-2c3a-476a-9b39-eead46d3c725",
            "identifier": {
              "use": null,
              "system": null,
              "value": "9dbcfce2-2c3a-476a-9b39-eead46d3c725"
            },
            "display": "Patient for the prescription",
            "type": "Patient"
          },
          "authorizingPrescription": [
            {
              "reference": "MedicationRequest/cfb938a1-5e95-44b0-9ac7-a59ce2d7d318",
              "identifier": {
                "use": null,
                "system": null,
                "value": "cfb938a1-5e95-44b0-9ac7-a59ce2d7d318"
              },
              "display": "Prescription for the Medication",
              "type": "MedicationRequest"
            }
          ],
          "quantity": {
            "value": 2000.0,
            "unit": null
          },
          "daysSupply": {
            "value": 100000.0,
            "unit": null
          },
          "whenHandedOver": null
        }
      }
    ]
    ```
