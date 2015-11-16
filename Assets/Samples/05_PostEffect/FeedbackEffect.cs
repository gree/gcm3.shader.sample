using UnityEngine;

[ExecuteInEditMode]
public class FeedbackEffect : MonoBehaviour {

	[SerializeField]
	Shader feedbackEffectShader;
	[SerializeField]
	float blurIntensity = 0.5f;
	[SerializeField]
	Vector2 pivot = new Vector2 (0.5f, 0.5f);
	[SerializeField]
	Vector3 offset = Vector3.zero;
	[SerializeField]
	float rotateAngle = 0.5f;
	[SerializeField]
	float scale = 1;
	[SerializeField]
	Texture2D mask;


	Material feedbackEffectMaterial;
	Material material {
		get
		{
			if(feedbackEffectMaterial == null)
			{
				feedbackEffectMaterial = new Material(feedbackEffectShader);
				feedbackEffectMaterial.hideFlags = HideFlags.HideAndDontSave;
			}
			return feedbackEffectMaterial;
		}
	}

	RenderTexture tmpTexture;


	public void Start () {
		// Disable this effect if not supported
		if (!SystemInfo.supportsImageEffects) {
			enabled = false;
			return;
		}
		
		if (!feedbackEffectShader || !feedbackEffectShader.isSupported) {
			enabled = false;
		}
	}
	
	public void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture) {

		if (feedbackEffectShader != null) {
			// Init
			if (tmpTexture == null) {
				// Grab tmpTexture
				int width = (int)(sourceTexture.width * 0.5f);
				int height = (int)(sourceTexture.height * 0.5f);
				tmpTexture = new RenderTexture(width, height, 0);
				tmpTexture.hideFlags = HideFlags.HideAndDontSave;
				tmpTexture.wrapMode = TextureWrapMode.Clamp;
				Graphics.Blit(sourceTexture, tmpTexture);

				// Set MaskTexture
				material.SetTexture("_MaskTex", mask);
			}
			
			// Set Matrix
			Vector3 newOffset = offset * 0.01f;
			Quaternion newRotation = Quaternion.Euler (0, 0, rotateAngle);
			Vector3 newScale = scale * Vector3.one;
			Vector3 newPivot = new Vector3(pivot.x, pivot.y, 0);
			Matrix4x4 t = Matrix4x4.TRS(-newPivot, Quaternion.identity, Vector3.one);
			Matrix4x4 matrix = Matrix4x4.TRS (newOffset, newRotation, newScale);
			Matrix4x4 tInv = Matrix4x4.TRS(newPivot, Quaternion.identity, Vector3.one);
			material.SetMatrix("_Matrix", tInv * matrix * t);

			// Set Alpha
			if(blurIntensity > 1)
				blurIntensity = 1;
			else if(blurIntensity < 0)
				blurIntensity = 0;
			material.SetFloat ("_Alpha", blurIntensity);

			// Mark Restore
			tmpTexture.MarkRestoreExpected();

			// Blit
			Graphics.Blit(tmpTexture, sourceTexture, material);
			Graphics.Blit(sourceTexture, tmpTexture);
			Graphics.Blit(sourceTexture, destTexture);
		}
	}
	
	public void OnDisable () {
		if (feedbackEffectMaterial) {
			DestroyImmediate(feedbackEffectMaterial);
		}
		if (tmpTexture) {
			DestroyImmediate(tmpTexture);
		}
	}
}
