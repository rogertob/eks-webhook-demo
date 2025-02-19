package main

import (
    "encoding/json"
    "fmt"
    "io/ioutil"
    "net/http"

    admissionv1 "k8s.io/api/admission/v1"
    corev1 "k8s.io/api/core/v1"
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func handleValidate(w http.ResponseWriter, r *http.Request) {
    body, err := ioutil.ReadAll(r.Body)
    if err != nil {
        http.Error(w, "Error reading body", http.StatusBadRequest)
        return
    }

    var admissionReview admissionv1.AdmissionReview
    if err := json.Unmarshal(body, &admissionReview); err != nil {
        http.Error(w, "Error unmarshaling body", http.StatusBadRequest)
        return
    }

    var pod corev1.Pod
    if err := json.Unmarshal(admissionReview.Request.Object.Raw, &pod); err != nil {
        http.Error(w, "Error unmarshaling pod", http.StatusBadRequest)
        return
    }

    // Check if required label exists
    allowed := false
    var result *metav1.Status
    if _, ok := pod.Labels["environment"]; ok {
        allowed = true
        result = &metav1.Status{Message: "Pod has required label"}
    } else {
        result = &metav1.Status{Message: "Pod missing required 'environment' label"}
    }

    admissionResponse := admissionv1.AdmissionResponse{
        UID:     admissionReview.Request.UID,
        Allowed: allowed,
        Result:  result,
    }

    admissionReview.Response = &admissionResponse
    resp, err := json.Marshal(admissionReview)
    if err != nil {
        http.Error(w, "Error marshaling response", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    w.Write(resp)
}

func main() {
    http.HandleFunc("/validate", handleValidate)
    fmt.Println("Starting webhook server on :8443")
    http.ListenAndServeTLS(":8443", "tls.crt", "tls.key", nil)
}
